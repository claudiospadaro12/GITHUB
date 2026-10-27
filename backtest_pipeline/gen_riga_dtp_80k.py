#!/usr/bin/env python3
"""Riga unica: Daytrade Pro Algo (Profalgo, 13 coppie da un grafico EURUSD D1 con OneChartSetup) con i set del venditore (prop, medium, high), tre anni e 2025 a Modello 1, poi 21 mesi a tick reali col set prop. 80.000 EUR. Uso: python3 gen_riga_dtp_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'Daytrade Pro Algo MT5.ex5'
PAIRS = 'EURUSD+GBPUSD+USDJPY+AUDUSD+XAUUSD+GBPJPY+USDCAD+EURJPY+EURNZD+EURAUD+NZDUSD+AUDJPY+CHFJPY'
# (nome, etichetta, LotPerBalance_step, MaxRiskMaxDD, PropFirmMaxDailyDD): dai .set del venditore v2.4
SETS = [('PROPFIRM', 'R27', '5000', '2.7', '4.0'), ('MEDIUM', 'R6', '2500', '6.0', '0.0'), ('HIGHRISK', 'R15', '1000', '15.0', '0.0')]
def imp(st, mr, dd): return 'RunOneChartSetup=true:b;OneChartSetupPairs=%s:s;Risk=99999:i;StartLots=0.01:d;LotPerBalance_step=%s:i;MaxRiskMaxDD=%s:d;PropFirmMaxDailyDD=%s:d;UseEquity=false:b;OnlyUp=false:b;CheckMargin=true:b;MaxNumberOfTrade=99:i;Randomization=0.0:d;FridayStopHour=25:i' % (PAIRS, st, mr, dd)
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for nome, e, st, mr, dd in SETS: runs.append((EX, anno, '1', 'D1', 'EURUSD', imp(st, mr, dd), '', '%s_M1_DTP_%s_%s' % (anno, nome, e)))
nome, e, st, mr, dd = SETS[0]; runs.append((EX, '2025', '4', 'D1', 'EURUSD', imp(st, mr, dd), '2026.10.01', '2025_M4_DTP_%s_%s' % (nome, e)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("DAYTRADE PRO ALGO (PROFALGO) CON I SET DEL VENDITORE NEI TRE MERCATI (80.000 EUR, DEMO, SOLO TESTER): dalla pagina del Market: si esegue su un grafico EURUSD GIORNALIERO (D1) con OneChartSetup acceso, 13 coppie (EURUSD, GBPUSD, USDJPY, AUDUSD, XAUUSD, GBPJPY, USDCAD, EURJPY, EURNZD, EURAUD, NZDUSD, AUDJPY, CHFJPY), e per i backtest il venditore dice che basta 1 minute OHLC (Modello 1). Il setaccio del 24/10 sull oro con i default non valeva niente (RunOneChartSetup spento, lotto fisso 0,01: 3 operazioni in due mesi). I set (v2.4) differiscono solo per LotPerBalance_step e MaxRiskMaxDD (prop 5000 e 2,7; medium 2500 e 6; high 1000 e 15) e per PropFirmMaxDailyDD (4 solo nel prop); il low risk e il prop meno il limite giornaliero, quindi non si ripete. Imposti: OneChartSetup e le 13 coppie, Risk=99999 (come nei set), StartLots, i tre input che cambiano, UseEquity, OnlyUp spento, CheckMargin, MaxNumberOfTrade 99, Randomization 0 (nel prop del venditore e 0). ATTENZIONE: la pagina e alla versione 4.51 (19/10/2026) e i set sono della v2.4: potrebbero non essere piu quelli consigliati. 13 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: 12 passate a Modello 1 (OHLC 1 minuto) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno dei 3 set; poi UNA corsa continua a tick reali di 21 mesi (01/01/2025-01/10/2026) col set prop (calibrazione e prova lunga). Se BCM non ha lo storico di una coppia in un anno (il 2013 e a rischio) la passata esce KO o con meno coppie: e una misura mancante e il referto elenca i simboli. Tempo: NON misurato; atteso da 2 a 6 ore in tutto; timeout 420 minuti per passata. Se un set manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_DTP_<data> (o lo zip finale). Criteri e previsioni: report/DAYTRADE_PRO_SET_TRE_ANNI_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Daytrade Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_DTP_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_DTP_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Daytrade Pro deve essere gia installato')
open('righe/RIGA_LANCIA_DTP_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
