#!/usr/bin/env python3
"""Riga unica ORDINATA DAL PIU CORTO AL PIU LUNGO: Luna AI Pro LotsizeStep 400 sui tre anni + calibrazione 2025 (Modello 1, pochi minuti ciascuna), poi Gold Reaper con le protezioni spente su 21 mesi (circa 3 ore, tick reali). Uso: python3 gen_riga_ordine_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
LUNA, GR = 'Luna AI Pro MT5.ex5', 'The Gold Reaper MT5.ex5'
LB = 'RunOneChartSetup=true:b;AutoLotMode=3:i;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;EnableNewsFilter=false:b;OneChartSetup_Pairs=EURAUD+GBPAUD+GBPCHF:s;LotsizeStep=400:i'
GRI = 'TradeFrequency=2:i;MaxAllowedDD=0.0:d;PropFirmMaxDailyDD=0.0:d;OnlyUp=false:b'
runs = [(LUNA, '2013', '1', 'M5', 'EURUSD', LB, '', '2013_M1_LUNA_LS400'), (LUNA, '2018', '1', 'M5', 'EURUSD', LB, '', '2018_M1_LUNA_LS400'),
        (LUNA, '2020', '1', 'M5', 'EURUSD', LB, '', '2020_M1_LUNA_LS400'), (LUNA, '2025', '1', 'M5', 'EURUSD', LB, '', '2025_M1_LUNA_LS400'),
        (GR, '2025', '4', 'H1', 'XAUUSD', GRI, '2026.10.01', '21MESI_M4_GOLDREAPER_PROTEZIONI_OFF')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("RIGA UNICA ORDINATA DAL PIU CORTO AL PIU LUNGO (80.000 EUR, DEMO, SOLO TESTER). PARTE 1, pochi minuti ciascuna (Modello 1, OHLC 1 minuto): LUNA AI PRO con LotsizeStep 400 (il livello basso del manuale) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025 come calibrazione contro la corsa a tick reali gia fatta (EURUSD M5, OneChartSetup, coppie EURAUD GBPAUD GBPCHF, AutoLotMode=3, AutoGMT spento con offset 1/1, filtro news spento perche il calendario non esiste nel tester). PARTE 2, circa 3 ore (tick reali): THE GOLD REAPER con le PROTEZIONI SPENTE (MaxAllowedDD=0 e PropFirmMaxDailyDD=0; TradeFrequency=2 e OnlyUp=false come il set di Claudio; tutti gli altri input default) su 21 mesi continui, 01/01/2025-01/10/2026, XAUUSD H1: da confrontare con la corsa gia fatta con le protezioni accese (+59.796 EUR, PF 2,89, DD equity 3.854 EUR, nessun giorno oltre -1,2%). 5 PASSATE in tutto, in questo ordine; ognuna a conto vuoto da 80000 EUR. Sono MISURE: non scelte di rischio ne indicazioni di acquisto. Per i forex vecchi, se BCM non ha lo storico M1 di una coppia nel 2013, la passata risulta KO e lo dice. TEMPO: circa 3-4 ore in tutto (la parte 1 pochi minuti, il Reaper circa 3 ore); timeout 420 minuti per passata. Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO; non usare Sospendi. PRIMA DI LANCIARE: nella Panoramica del mercato devono essere VISIBILI EURUSD, EURAUD, GBPAUD, GBPCHF e XAUUSD. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_ORDINE_<data> (o lo zip finale). Criteri e previsioni: report/ORDINE_LUNA_TRE_ANNI_E_REAPER_PROTEZIONI_OFF_CRITERI_2026-10-26.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 2){ throw 'Mancano EA nel Market di questo terminale (servono Luna AI Pro MT5.ex5 e The Gold Reaper MT5.ex5). Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_ORDINE_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_ORDINE_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Luna AI Pro MT5 e The Gold Reaper MT5 devono essere gia installati')
open('righe/RIGA_LANCIA_ORDINE_LUNA_E_REAPER_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
