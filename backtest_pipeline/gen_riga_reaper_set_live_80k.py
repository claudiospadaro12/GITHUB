#!/usr/bin/env python3
"""Riga unica: The Gold Reaper con il set del segnale live del venditore (MaxAllowedDD 30) e con una sua variante a MaxAllowedDD 9 + limite 4%, e il set prop con Randomization 50 (due corse per anno): 2013, 2018, 2020, 2025 a Modello 1, 80.000 EUR; TUTTI gli input imposti. Uso: python3 gen_riga_reaper_set_live_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
COM = 'TradeFrequency=2:i;FakeOutFilter=2:i;UseHL_TrailingSL=true:b;Risk=1234:i;StartLots=0.01:d;MaxRiskPerStrategy_=1.0:d;ManualBalance=0.0:d;UseWeightedLots=true:b;'
def GRI(dd, dg, up, ve, ra): return COM + 'MaxAllowedDD=%s:d;PropFirmMaxDailyDD=%s:d;OnlyUp=%s:b;Virtual_expiration=%s:b;Randomization=%s:d' % (dd, dg, up, ve, ra)
CONF = [('LIVE30', GRI('30.0', '0.0', 'true', 'false', '0.0')), ('LIVE9', GRI('9.0', '4.0', 'true', 'false', '0.0')),
        ('R50A', GRI('9.0', '4.0', 'false', 'true', '50.0')), ('R50B', GRI('9.0', '4.0', 'false', 'true', '50.0'))]
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for tag, inp in CONF: runs.append((EX, anno, '1', 'H1', 'XAUUSD', inp, '', '%s_M1_GR_%s' % (anno, tag)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER CON IL SET DEL SEGNALE LIVE DEL VENDITORE E CON RANDOMIZATION 50 (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1, TUTTI gli input imposti (lezione dello Stability: gli input non imposti tengono l ultimo valore). 16 PASSATE a Modello 1 (OHLC 1 minuto) sui tre anni 2013, 2018, 2020 e sul 2025, per ognuna 4 configurazioni: LIVE30 = set del segnale live del venditore (TradeFrequency 2, MaxAllowedDD 30, limite giornaliero 0, OnlyUp true, Virtual_expiration false); LIVE9 = come il live ma MaxAllowedDD 9 e limite giornaliero 4 (isola OnlyUp true e Virtual_expiration false rispetto al nostro set prop); R50A e R50B = il nostro set prop (MaxAllowedDD 9, limite 4, OnlyUp false, Virtual_expiration true) con Randomization 50 come nel file del venditore, DUE volte identiche per vedere se il risultato cambia da una corsa all altra. NOTA: FakeOutFilter=2 e gia il default nelle nostre corse (lo mostra il report), quindi non e una differenza del set live. Tempo: ogni passata circa 3-6 minuti (misurato sulle altre righe del Reaper a Modello 1): in tutto circa 1-1,5 ore; timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_REAPER_SETLIVE_<data> (o lo zip finale). Criteri e previsioni: report/REAPER_SET_LIVE_E_RANDOMIZATION_CRITERI_2026-10-29.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_SETLIVE_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_SETLIVE_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: circa 1-1,5 ore in tutto (stima); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_REAPER_SETLIVE_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
