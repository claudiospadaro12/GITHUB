#!/usr/bin/env python3
"""Riga unica: Stability Pro (Profalgo, griglia forex AUDCAD+AUDNZD+NZDCAD su EURUSD M5 con OneChartSetup) con AutoLotMode=3 (lotto a gradini: modo usato nel test del venditore) a 4 livelli di LotsizeStep, sui tre anni e 2025 a Modello 1, poi 2025 a tick reali. 80.000 EUR. Uso: python3 gen_riga_stab_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'Stability Pro MT5.ex5'
SB = 'RunOneChartSetup=true:b;OneChartSetup_Pairs=AUDCAD+AUDNZD+NZDCAD:s;AutoLotMode=3:i;OnlyUp=true:b;MaxAllowedDD_=0.0:d;HardSLDistance=2000.0:d;LotsizeStep_manually='
LIV = ['10000', '5000', '2000', '1000']
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for ls in LIV: runs.append((EX, anno, '1', 'M5', 'EURUSD', SB + ls + ':i', '', '%s_M1_STAB_LS%s' % (anno, ls)))
for ls in LIV: runs.append((EX, '2025', '4', 'M5', 'EURUSD', SB + ls + ':i', '', '2025_M4_STAB_LS%s' % ls))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("STABILITY PRO (PROFALGO) NEI TRE MERCATI, VERSIONE CORRETTA (80.000 EUR, DEMO, SOLO TESTER): griglia forex con mediazione sulle coppie AUDCAD, AUDNZD e NZDCAD, girata come dice il venditore su EURUSD M5 con OneChartSetup acceso (un solo grafico). CORREZIONE DEL 28/10: nella superriga le 20 passate di questo EA erano KO perche gli input erano scritti con i nomi del report del venditore (MaxAllowedDD e LotsizeStep) che in questo EA NON esistono: i nomi veri, letti dal report del tester, sono MaxAllowedDD_ e LotsizeStep_manually. Quelle 4 corse erano la stessa corsa (default, passo manuale 0: lotti circa 0,4-0,53 a 80.000 EUR). Questa riga impone AutoLotMode=3, quattro livelli di LotsizeStep_manually (10000, 5000, 2000, 1000: se vale la regola 0,01 lotti ogni passo di saldo, a 80.000 EUR circa 0,08, 0,16, 0,4 e 0,8 lotti; da verificare dai volumi delle corse), OnlyUp=true, MaxAllowedDD_=0 (nessuno stop di sicurezza: e il default) e HardSLDistance=2000 (default). 20 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: prima 16 passate a Modello 1 (OHLC 1 minuto: il venditore dice che basta, l EA usa solo i prezzi di apertura delle candele) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno dei 4 livelli; poi 4 passate del 2025 a TICK REALI (calibrazione). Tempo misurato nella superriga del 28/10 (stesse passate): circa 1-2 minuti per le passate a Modello 1 e circa 16 minuti per quelle a tick reali: in tutto circa 1,5 ore; timeout 420 minuti per passata. Se un livello manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\ANNO80K_STAB_<data> (o lo zip finale). Criteri e previsioni: report/STABILITY_PRO_LOTSIZESTEP_TRE_ANNI_CRITERI_2026-10-27.md e la correzione del 28/10 nello stesso file. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Stability Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_STAB_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_STAB_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Stability Pro deve essere gia installato')
open('righe/RIGA_LANCIA_STAB_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
