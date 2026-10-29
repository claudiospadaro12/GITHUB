#!/usr/bin/env python3
"""Riga unica: The Gold Reaper a LOTTO MINIMO 0,01 (MaxAllowedDD=0, misurato il 27/10) su 16 anni 2008-2023 a Modello 1 H1 + 3 anni (2013, 2018, 2020) su D1, per confrontare col test 2008-2024 di Wim a lotto fisso. 80.000 EUR. Uso: python3 gen_riga_reaper_fisso_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
GRI = 'TradeFrequency=2:i;MaxAllowedDD=0.0:d;PropFirmMaxDailyDD=0.0:d;OnlyUp=false:b'
runs = []
for anno in ('2013', '2018', '2020'): runs.append((EX, anno, '1', 'D1', 'XAUUSD', GRI, '', '%s_M1_GR_FISSO_D1' % anno))
for anno in [str(y) for y in range(2008, 2024)]: runs.append((EX, anno, '1', 'H1', 'XAUUSD', GRI, '', '%s_M1_GR_FISSO_H1' % anno))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER A LOTTO MINIMO SU 16 ANNI (2008-2023), PER CONFRONTARLO COL TEST DI WIM (80.000 EUR, DEMO, SOLO TESTER): XAUUSD. Input imposti: TradeFrequency=2, MaxAllowedDD=0 (con 0 il lotto cade a 0,01 su tutte le operazioni: misurato il 27/10), PropFirmMaxDailyDD=0, OnlyUp=false. Serve a confrontare con il test lungo di Wim (GoldReaper_WSC_V1.0, 2008-2024, lotto fisso 0,01, TradeFrequency 2, positivo in tutti i 16 anni completi) con i nostri dati BCM e la nostra versione, e a misurare gli anni fuori dal periodo 2013-2023 che il venditore dichiara di aver ottimizzato (2008-2012). 19 PASSATE a conto vuoto da 80000 EUR, a Modello 1 (OHLC 1 minuto), ordinate: prima 3 passate su grafico GIORNALIERO D1 (2013, 2018, 2020: Wim usa il grafico D1, noi H1: servono a vedere se cambia qualcosa), poi 16 passate su H1, una per anno dal 2008 al 2023. Tempo: NON misurato con questo lotto; una passata annuale a Modello 1 del Reaper ha richiesto circa 3-4 minuti: attesi da 1 a 1,5 ore in tutto; timeout 420 minuti per passata. Se BCM non ha le barre M1 di un anno (e probabile per i primi anni) la passata esce KO o con zero operazioni: e una misura mancante, non un errore. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_REAPER_FISSO_<data> (o lo zip finale). Criteri e previsioni: report/REAPER_LOTTO_FISSO_16_ANNI_CRITERI_2026-10-29.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_FISSO_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_FISSO_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: da 1 a 1,5 ore in tutto (stima, non misurata); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_REAPER_FISSO_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
