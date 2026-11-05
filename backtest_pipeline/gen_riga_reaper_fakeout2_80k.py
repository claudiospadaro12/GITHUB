#!/usr/bin/env python3
"""Riga unica: The Gold Reaper, nostro set prop (MaxAllowedDD 9, limite 4, OnlyUp false, Virtual_expiration true, Randomization 0), con FakeOutFilter 0/1/2/3 (Off/Low/Medium/High) su 2013, 2018, 2020, 2025 a Modello 1, 80.000 EUR, XAUUSD H1; TUTTI gli input imposti. 16 passate. Criteri: report/REAPER_FAKEOUT2_CRITERI_2026-11-05.md. Uso: python3 gen_riga_reaper_fakeout_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
def COMF(fo): return 'TradeFrequency=2:i;FakeOutFilter=%d:i;UseHL_TrailingSL=true:b;Risk=1234:i;StartLots=0.01:d;MaxRiskPerStrategy_=1.0:d;ManualBalance=0.0:d;UseWeightedLots=true:b;MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b;Virtual_expiration=true:b;Randomization=0.0:d' % fo
CONF = [('F1', COMF(1)), ('F2', COMF(2))]
runs = []
for anno in ('2015', '2019', '2022', '2023', '2024'):
    for tag, inp in CONF: runs.append((EX, anno, '1', 'H1', 'XAUUSD', inp, '', '%s_M1_GR_%s' % (anno, tag)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER: FASE 2 DEL TEST FAKE BREAKOUT (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1, TUTTI gli input imposti. Stesso set prop (MaxAllowedDD 9, limite 4, OnlyUp false, Virtual_expiration true, Randomization 0), solo FakeOutFilter 1 (Low) contro 2 (Medium) su 5 anni NUOVI: 2015, 2019, 2022, 2023 e 2024 (il 2023 sostituisce il 2024 se i dati BCM del 2024 mancano). 10 PASSATE a Modello 1 (OHLC 1 minuto), circa 40-60 minuti in tutto, timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra. Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_REAPER_FAKEOUT2_<data> (o lo zip finale). Criteri e previsioni: report/REAPER_FAKEOUT_CRITERI_2026-11-05.md (sezione FASE 2). Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_FAKEOUT2_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_FAKEOUT2_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: circa 1-1,5 ore in tutto (stima); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_REAPER_FAKEOUT2_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
