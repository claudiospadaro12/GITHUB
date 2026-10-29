#!/usr/bin/env python3
"""Riga unica: Goldbot One con i set del venditore (Risk=3: PropFirm_10_5, PropFirm_5_2.5, LowRisk_Max15DD): 2013, 2018, 2020 e 2025 a Modello 1, 21 mesi a Modello 1 (3 passate) e a tick reali (PF105), 80.000 EUR, D1, TUTTI gli input imposti. Uso: python3 gen_riga_goldbot_setvend_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'Goldbot One MT5.ex5'
COM = ('Risk=3:i;StartLots=0.01:d;LotPerBalance_step=1000:i;ManualBalance=0.0:d;UseEquity=false:b;CheckMargin=true:b;AdjustLotsizeToVariableValues=true:b;ResetHighestBalance=false:b;OnlyUp=false:b;'
       'Randomization=0.0:d;FakeOutFilter=1:i;FridayStopHour=25:i;Virtual_expiration=true:b;EnableVirtualSLTP=false:b;MaxSpread=500.0:d;AllowBuyTrades=true:b;AllowSellTrades=true:b;'
       'RunStrategyA=true:b;RunStrategyB=true:b;RunStrategyC=true:b;RunStrategyD=true:b;RunStrategyE=true:b;RunStrategyF=true:b;RunStrategyG=true:b;RunStrategyH=true:b;')
def GBI(mr, dg): return COM + 'MaxRiskPerStrategy=%s:d;PropFirmMaxDailyDD=%s:d' % (mr, dg)
CONF = [('PF105', GBI('2.0', '4.0')), ('PF525', GBI('1.0', '2.0')), ('LOW3', GBI('3.0', '0.0'))]
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for tag, inp in CONF: runs.append((EX, anno, '1', 'D1', 'XAUUSD', inp, '', '%s_M1_GB_%s' % (anno, tag)))
for tag, inp in CONF: runs.append((EX, '2025', '1', 'D1', 'XAUUSD', inp, '2026.10.01', '21M_M1_GB_%s' % tag))
runs.append((EX, '2025', '4', 'D1', 'XAUUSD', CONF[0][1], '2026.10.01', '21M_M4_GB_PF105'))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("GOLDBOT ONE CON I SET DEL VENDITORE (Risk=3, Max Risk Per Strategy) A 80.000 EUR (DEMO, SOLO TESTER): XAUUSD D1, TUTTI gli input imposti. 16 PASSATE: 2013, 2018, 2020 e 2025 a Modello 1 per tre configurazioni (PF105 = PropFirm_10_5: MaxRisk 2 e limite giornaliero 4; PF525 = PropFirm_5_2.5: MaxRisk 1 e limite 2; LOW3 = LowRisk_Max15DD: MaxRisk 3, nessun limite) = 12 passate; poi 21 mesi (01/01/2025-01/10/2026) a Modello 1 per le tre configurazioni (LOW3 controlla la sonda 3 del 21/10) e a tick reali per PF105 = 4 passate. Il test del 26/10 era con Risk=9999 e step 6000: NON e questo. TEMPO: Goldbot One D1 e veloce (da 3 a 5 minuti a passata a Modello 1; i tick reali circa 30-60 minuti): stima 1,5-2,5 ore in tutto; timeout 420 minuti per passata. Criteri e previsioni scritti PRIMA dei numeri: report/GOLDBOT_ONE_SET_VENDITORE_CRITERI_2026-10-29.md. Non giudica acquisti ne taglie. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo. MT5 deve essere CHIUSO")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Goldbot One nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_GOLDBOT_SETVEND_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_GOLDBOT_SETVEND_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Goldbot One deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: circa 1,5-2,5 ore in tutto (stima); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_GOLDBOT_SETVEND_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
