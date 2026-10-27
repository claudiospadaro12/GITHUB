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
SETS = [('PROPFIRM', 'R1', '1.0', '4.0'), ('LOWRISK', 'R15', '1.5', '0.0'), ('MEDIUM', 'R3', '3.0', '0.0'), ('HIGHRISK', 'R6', '6.0', '0.0')]
def imp(r, dd): return 'Risk=3:i;MaxRiskPerStrategy=%s:d;PropFirmMaxDailyDD=%s:d' % (r, dd)
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for nome, e, r, dd in SETS: runs.append((EX, anno, '1', 'D1', 'XAUUSD', imp(r, dd), '', '%s_M1_GTP_%s_%s' % (anno, nome, e)))
for nome, e, r, dd in SETS[1:]: runs.append((EX, '2025', '4', 'D1', 'XAUUSD', imp(r, dd), '', '2025_M4_GTP_%s_%s' % (nome, e)))
nome, e, r, dd = SETS[0]; runs.append((EX, '2025', '4', 'D1', 'XAUUSD', imp(r, dd), '2026.10.01', '2025_M4_GTP_%s_%s' % (nome, e)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("GOLD TRADE PRO CON I SET DEL VENDITORE NEI TRE MERCATI (80.000 EUR, DEMO, SOLO TESTER): XAUUSD D1 (grafico giornaliero, come dice la pagina del Market). I 4 file .set del venditore (prop firm, low, medium, high risk) differiscono SOLO per MaxRiskPerStrategy (1, 1,5, 3, 6) e PropFirmMaxDailyDD (4 solo nel prop); la riga impone Risk=3 (lotto da rischio per strategia: e quello dei set) piu quei due input. ATTENZIONE: i test del 19/10 sul Gold Trade Pro erano a lotto FISSO 0,01 (Risk=0), non nella configurazione del venditore: questi sono i primi con i suoi set. Tutti gli altri input restano al default dell EA (verificato uguale ai valori dei set dal report del 19/10). Il filtro news NFP resta acceso ma il calendario non esiste nel tester (usa date interne e AutoGMT con offset 2/3, orologio NON verificato su BCM); FridayStopHour 25 nei set: nessuna chiusura del venerdi. 20 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: prima 16 passate a Modello 1 (OHLC 1 minuto) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno dei 4 set; poi 3 passate del 2025 a TICK REALI (low, medium, high), infine UNA corsa continua a tick reali di 21 mesi (01/01/2025-01/10/2026) col set prop firm (serve da calibrazione e da prova lunga). Tempo: NON misurato con questi set; a lotto fisso un mese a tick reali richiedeva circa 7 minuti, quindi atteso circa 1,5 ore per anno a tick reali: in tutto da 5 a 9 ore; timeout 420 minuti per passata. Se un set manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_GTP_<data> (o lo zip finale). Criteri e previsioni: report/GOLD_TRADE_PRO_SET_TRE_ANNI_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Goldtrade Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_GTP_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_GTP_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Gold Trade Pro deve essere gia installato')
open('righe/RIGA_LANCIA_GTP_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
