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
BASE = 'RunOneChartSetup=true:b;OneChartSetup_Pairs=AUDCAD+AUDNZD+NZDCAD:s;OnlyUp=true:b;MaxAllowedDD_=0.0:d;'
# (etichetta, input che cambiano): tutte 2025, Modello 1; la prima e il controllo (deve dare 458 operazioni e +14.026,26)
SONDE = [('P1_modo3_rischio1', 'AutoLotMode=3:i;AutoLotsizeRisk=1.0:d;HardSLDistance=2000.0:d'),
         ('P2_modo3_rischio025', 'AutoLotMode=3:i;AutoLotsizeRisk=0.25:d;HardSLDistance=2000.0:d'),
         ('P3_modo3_rischio2', 'AutoLotMode=3:i;AutoLotsizeRisk=2.0:d;HardSLDistance=2000.0:d'),
         ('P4_modo3_saldomanuale20000', 'AutoLotMode=3:i;AutoLotsizeRisk=1.0:d;ManualBalance=20000.0:d;HardSLDistance=2000.0:d'),
         ('P5_modo3_stop4000', 'AutoLotMode=3:i;AutoLotsizeRisk=1.0:d;HardSLDistance=4000.0:d'),
         ('P6_modo1_lotto001', 'AutoLotMode=1:i;StartLots=0.01:d;HardSLDistance=2000.0:d'),
         ('P7_modo1_lotto010', 'AutoLotMode=1:i;StartLots=0.1:d;HardSLDistance=2000.0:d'),
         ('P8_modo3_ddperc3', 'AutoLotMode=3:i;AutoLotsizeRisk=1.0:d;MaxAllowedDDPerc=3.0:d;HardSLDistance=2000.0:d'),
         ('P9_modo3_dd2000', 'AutoLotMode=3:i;AutoLotsizeRisk=1.0:d;MaxAllowedDD_=2000.0:d;HardSLDistance=2000.0:d')]
runs = []
for et, imp in SONDE:
    inp = BASE + imp
    if 'MaxAllowedDD_=2000' in imp: inp = inp.replace('MaxAllowedDD_=0.0:d;', '')
    runs.append((EX, '2025', '1', 'M5', 'EURUSD', inp, '', '2025_M1_STABSONDA_' + et))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("STABILITY PRO: SONDA PER TROVARE L INPUT CHE COMANDA IL LOTTO (80.000 EUR, DEMO, SOLO TESTER): EURUSD M5 con OneChartSetup (AUDCAD+AUDNZD+NZDCAD), solo il 2025 a Modello 1 (OHLC 1 minuto, circa 1-2 minuti a passata). PERCHE: nella superriga e nella riga corretta del 28/10 il LotsizeStep_manually non cambiava nulla (4 livelli identici al centesimo, lotti 0,41-0,53 come il default), e con AutoLotMode=2 non cambiava nemmeno AutoLotsizeRisk. Non sappiamo quale input comandi il lotto: questa riga lo cerca. IPOTESI DA VERIFICARE: con AutoLotMode=3 il lotto e rischio percentuale / distanza dello stop (circa 1% di 80.000 su HardSLDistance 2000 punti = circa 0,5 lotti) e quindi dipende da AutoLotsizeRisk, da HardSLDistance o da ManualBalance. 9 PASSATE a conto vuoto da 80000 EUR, ognuna cambia UN input rispetto al controllo P1 (modo 3, rischio 1, stop 2000: deve riprodurre 458 operazioni e +14.026,26): P2 rischio 0,25; P3 rischio 2; P4 saldo manuale 20000; P5 stop 4000; P6 lotto fisso 0,01 (modo 1); P7 lotto fisso 0,10 (modo 1); P8 MaxAllowedDDPerc 3; P9 MaxAllowedDD_ 2000. Se un input e di tipo diverso (intero invece di decimale) il report lo mostra e la passata esce KO: e una misura. Tempo: circa 15-25 minuti in tutto; timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_STABSONDA_<data> (o lo zip finale). Criteri e previsioni: report/STABILITY_PRO_LOTSIZESTEP_TRE_ANNI_CRITERI_2026-10-27.md (sezione sonda del 29/10). Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca Stability Pro nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_STABSONDA_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_STABSONDA_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Stability Pro deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: circa 15-25 minuti in tutto (9 passate a Modello 1 di un anno); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_STAB_SONDA_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
