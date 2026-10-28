#!/usr/bin/env python3
"""Riga unica: The Gold Reaper col set prop (TradeFrequency 2, limite giornaliero 4, OnlyUp spento) con MaxAllowedDD 6, 9, 12 e 15 (decide anche il lotto): 2013, 2018, 2020 e 2025 a Modello 1, poi 21 mesi a tick reali per 12 e 15, 80.000 EUR. Uso: python3 gen_riga_reaper_maxdd_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
def GRI(v): return 'TradeFrequency=2:i;MaxAllowedDD=%s:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b' % v
VAL = ['6.0', '9.0', '12.0', '15.0']
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for v in VAL: runs.append((EX, anno, '1', 'H1', 'XAUUSD', GRI(v), '', '%s_M1_GR_DD%s' % (anno, v.split('.')[0])))
for v in ('12.0', '15.0'): runs.append((EX, '2025', '4', 'H1', 'XAUUSD', GRI(v), '2026.10.01', '2025_M4_GR_DD%s' % v.split('.')[0]))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER CON MaxAllowedDD DIVERSI (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1. Input imposti: TradeFrequency=2, PropFirmMaxDailyDD=4 (limite giornaliero ACCESO come nel set prop), OnlyUp=false, e MaxAllowedDD a 6, 9, 12 e 15. In questo EA MaxAllowedDD decide anche il lotto (con 0 il lotto cade a 0,01, misurato il 27/10): qui serve a vedere come cambiano rendimento, drawdown di equity, giorno peggiore e tempo per arrivare a +8.000 al crescere del lotto. Il 9 e il valore gia misurato (21 mesi del 20/10: +59.796, 791 operazioni, DD equity 3.854; tre anni del 26/10): serve da CONTROLLO, i numeri devono uscire uguali. 18 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: prima 16 passate a Modello 1 (OHLC 1 minuto, pochi minuti ciascuna) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno dei 4 valori; poi 2 corse continue a TICK REALI di 21 mesi (01/01/2025-01/10/2026) con MaxAllowedDD 12 e 15 (circa 3 ore ciascuna: quella con 9 ha richiesto 10.835 secondi; il lotto piu grande puo allungare). In tutto da 7 a 8 ore (stima). Timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito): le 16 passate a Modello 1 bastano gia per i tre anni. Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_REAPER_MAXDD_<data> (o lo zip finale). Criteri e previsioni: report/REAPER_MAXALLOWEDDD_CRITERI_2026-10-28.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_MAXDD_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_MAXDD_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
t = t.replace('TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.', 'TEMPO: da 7 a 8 ore in tutto (stima, non misurata); timeout 420 minuti per passata.')
open('righe/RIGA_LANCIA_REAPER_MAXDD_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
