#!/usr/bin/env python3
"""Riga unica: The DAX Morning Scalp (njtrading) sul DAX di BCM (D30EUR M15) con 5 set del venditore, ognuno con DUE ore (inverno e estate) per tenere conto che BCM e UTC+1 fisso; 21 mesi a tick reali, 80.000 EUR. Uso: python3 gen_riga_daxms_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The DAX Morning Scalp.ex5'
BASE = [('Automatic_DAX_Opening_hour', 'false', 'b'), ('Manual_DAX_opening_hour_based_on_broker_time', '10', 'i'), ('AggressiveMode_Start_minute', '20', 'i'), ('NormalTrading_Start_minute', '30', 'i'), ('ATRperiod', '5', 'i'), ('EntryDiviation', '400', 'i'), ('NormalMode', 'true', 'b'), ('AggressiveMode', 'true', 'b'), ('ReversalMode', 'false', 'b'), ('Safetymode', 'false', 'b'), ('UltraSafetyMode', 'false', 'b'), ('Risk_of_account_balance_per_trade_in_percent', '1.0', 'd'), ('StaticLotSizeOption', 'false', 'b'), ('LotSize', '0.0', 'd'), ('PredeterminedStopLoss', '0', 'i'), ('PredeterminedStopLoss_AggressiveMode', '0', 'i'), ('ATRstop', '1.2', 'd'), ('StopLossDiviation', '0', 'i'), ('ATRtp', '0.8', 'd'), ('TakeProfit', '1000', 'i'), ('TakeProfit_AggressiveTrades', '2000', 'i'), ('TakeProfit_UltraSafetyMode', '1000', 'i'), ('TrailingStopLoss', 'false', 'b'), ('BreakEvenStop', 'false', 'b'), ('TslTrigger', '500.0', 'd'), ('ATRtrailingDistance', '1.2', 'd'), ('PointTrailingDistance', '0.0', 'd'), ('OrderDelete_hour', '15', 'i'), ('OrderDelete_min', '14', 'i'), ('Buy_Orders', 'true', 'b'), ('Sell_orders', 'true', 'b'), ('Monday_trading', 'true', 'b'), ('Tuesday_trading', 'true', 'b'), ('Wednesday_trading', 'true', 'b'), ('Thursday_trading', 'true', 'b'), ('Friday_trading', 'true', 'b')]
SETS = [('DEFAULT', 'DF', {}), ('SENZAAGGR', 'NA', {'AggressiveMode': 'false'}),
        ('UNOAUNO', 'U1', {'PredeterminedStopLoss': '3100', 'TakeProfit': '3100', 'TakeProfit_AggressiveTrades': '0', 'TakeProfit_UltraSafetyMode': '0'}),
        ('REVERSAL', 'RV', {'NormalMode': 'false', 'AggressiveMode': 'false', 'ReversalMode': 'true', 'EntryDiviation': '0', 'ATRstop': '0.9', 'TrailingStopLoss': 'true', 'BreakEvenStop': 'true', 'TslTrigger': '0.0', 'ATRtrailingDistance': '0.6', 'OrderDelete_hour': '11', 'OrderDelete_min': '30'}),
        ('BRUNCH', 'BR', {'Manual_DAX_opening_hour_based_on_broker_time': '11', 'NormalTrading_Start_minute': '45', 'EntryDiviation': '500', 'AggressiveMode': 'false', 'ATRstop': '1.4', 'ATRtp': '2.0', 'TrailingStopLoss': 'true', 'BreakEvenStop': 'true', 'TslTrigger': '0.0', 'ATRtrailingDistance': '0.6', 'OrderDelete_hour': '13', 'OrderDelete_min': '0'})]
def imp(over, sub):
    # ore del venditore (broker = IT+1 tutto l anno) -> BCM (UTC+1 fisso): inverno -1, estate -2
    out = []
    for k, v, t in BASE:
        v = over.get(k, v)
        if k in ('Manual_DAX_opening_hour_based_on_broker_time', 'OrderDelete_hour'): v = str(int(v) - sub)
        out.append('%s=%s:%s' % (k, v, t))
    return ';'.join(out)
runs = []
for nome, e, over in SETS:
    for stag, sub in (('W', 1), ('S', 2)):
        runs.append((EX, '2025', '4', 'M15', 'D30EUR', imp(over, sub), '2026.10.01', '21MESI_M4_DAXMS_%s_%s' % (nome, stag)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE DAX MORNING SCALP (NJTRADING, 30 USD) SUL DAX DI BCM (80.000 EUR, DEMO, SOLO TESTER): D30EUR M15, 21 mesi (01/01/2025-01/10/2026) a TICK REALI. 5 set del venditore: default v2.31 (modo aggressivo acceso), default senza aggressivo, 1 a 1 (stop e take profit 3100 punti), reversal mode, brunch 2024. OROLOGIO: i set sono scritti per un broker con ora IT+1 tutto l anno; BCM e UTC+1 fisso, quindi le ore (apertura del DAX 09:00 italiane e cancellazione ordini) valgono 1 ora in meno d inverno e 2 in meno d estate. Per questo ogni set gira DUE volte: con le ore d inverno (W) e con quelle d estate (S); il lettore prende da ogni corsa solo i deal della stagione giusta (inverno: fino al 29/03/2025, dal 26/10/2025 al 28/03/2026; estate: dal 30/03/2025 al 25/10/2025 e dal 29/03/2026). 10 PASSATE a conto vuoto da 80000 EUR, tutte lunghe uguale: l EA opera solo la mattina, quindi ciascuna e attesa breve (da pochi minuti a circa mezz ora); in tutto da 1 a 3 ore; timeout 420 minuti per passata. Imposti tutti gli input del set (rischio 1% per operazione). Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_DAXMS_<data> (o lo zip finale). Criteri e previsioni: report/DAX_MORNING_SCALP_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The DAX Morning Scalp nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_DAXMS_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_DAXMS_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The DAX Morning Scalp deve essere gia installato')
open('righe/RIGA_LANCIA_DAXMS_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
