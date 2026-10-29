#!/usr/bin/env python3
"""SONDA (29/10): quale input comanda il lotto. Riga unica: Stability Pro (Profalgo, griglia forex AUDCAD+AUDNZD+NZDCAD su EURUSD M5 con OneChartSetup) con AutoLotMode=3 (lotto a gradini: modo usato nel test del venditore) a 4 livelli di LotsizeStep, sui tre anni e 2025 a Modello 1, poi 2025 a tick reali. 80.000 EUR. Uso: python3 gen_riga_stab_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'Stability Pro MT5.ex5'
# TUTTI gli input che abbiamo variato nei giri precedenti sono imposti (gli input non imposti tengono l ultimo valore usato nel tester: lezione della sonda del 29/10)
def inp(mb): return ('RunOneChartSetup=true:b;OneChartSetup_Pairs=AUDCAD+AUDNZD+NZDCAD:s;enableBuyTrades=true:b;enableSellTrades=true:b;Max_Spread_=18.0:d;UseVirtualExit=false:b;commission=0.0:d;'
    'HardSLDistance=2000.0:d;SafetyClosing=0:i;MaxAllowedDD_=0.0:d;MaxAllowedDDPerc=0.0:d;UseEADrawdownOnly=true:b;'
    'ManualBalance=%s:d;AutoLotMode=3:i;StartLots=0.01:d;AutoLotsizeRisk=1.0:d;LotsizeStep_manually=0:i;BalanceSource=1:i;OnlyUp=true:b;ResetHighestBalance=false:b;ResetHighestBalanceOnWithdrawal=true:b;MaxLotsBroker=100.0:d' % mb)
LIV = ['40000.0', '30000.0', '20000.0', '10000.0']
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for mb in LIV: runs.append((EX, anno, '1', 'M5', 'EURUSD', inp(mb), '', '%s_M1_STAB_MB%s' % (anno, mb.split('.')[0])))
for mb in LIV: runs.append((EX, '2025', '4', 'M5', 'EURUSD', inp(mb), '', '2025_M4_STAB_MB%s' % mb.split('.')[0]))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("STABILITY PRO CON ManualBalance A QUATTRO LIVELLI, RIGA CORRETTA (80.000 EUR, DEMO, SOLO TESTER): EURUSD M5 con OneChartSetup (AUDCAD+AUDNZD+NZDCAD). La sonda del 29/10 ha mostrato che in AutoLotMode=3 il lotto e proporzionale al saldo usato per il calcolo e che ManualBalance e la leva per ridurlo (ManualBalance 20.000 su un conto da 80.000: lotti circa un quinto-un quarto, DD di equity 5,2% invece di 21,3%); LotsizeStep_manually e AutoLotsizeRisk quasi non contano. Questa riga impone ManualBalance 40.000, 30.000, 20.000 e 10.000 e TUTTI gli input dell EA (anche LotsizeStep_manually=0, StartLots, AutoLotsizeRisk, HardSLDistance, MaxAllowedDD_, MaxAllowedDDPerc): gli input non imposti tengono l ultimo valore usato nel tester, errore della sonda. 20 PASSATE a conto vuoto da 80000 EUR, dal piu corto al piu lungo: 16 a Modello 1 (OHLC 1 minuto, circa 1-2 minuti l una) sui tre anni 2013, 2018, 2020 e sul 2025 per ognuno dei 4 livelli; poi 4 a TICK REALI del 2025 (circa 16 minuti l una, calibrazione). In tutto circa 1,5 ore; timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_STABMB_<data> (o lo zip finale). Criteri e previsioni: report/STABILITY_PRO_LOTSIZESTEP_TRE_ANNI_CRITERI_2026-10-27.md (sezione ManualBalance del 29/10). Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Stability Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_STABMB_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_STABMB_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Stability Pro deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: circa 1,5 ore in tutto (stima); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_STAB_MB_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
