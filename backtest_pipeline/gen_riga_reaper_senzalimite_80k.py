#!/usr/bin/env python3
"""Riga unica: The Gold Reaper col set di Claudio MA con il solo limite giornaliero spento (PropFirmMaxDailyDD=0; MaxAllowedDD=9 invariato, perche decide anche il lotto): 2013, 2018, 2020 a Modello 1 e 21 mesi a tick reali, 80.000 EUR. Uso: python3 gen_riga_reaper_senzalimite_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Reaper MT5.ex5'
GRI = 'TradeFrequency=2:i;MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=0.0:d;OnlyUp=false:b'
runs = [(EX, a, '1', 'H1', 'XAUUSD', GRI, '', '%s_M1_GR_SENZA_LIMITE_GIORNALIERO' % a) for a in ('2013', '2018', '2020')]
runs.append((EX, '2025', '4', 'H1', 'XAUUSD', GRI, '2026.10.01', '21MESI_M4_GR_SENZA_LIMITE_GIORNALIERO'))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD REAPER COL SET DI CLAUDIO MA SENZA IL LIMITE GIORNALIERO (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1. Input imposti: TradeFrequency=2, MaxAllowedDD=9 (INVARIATO: in questo EA decide anche il lotto, con 0 il lotto cade a 0,01 come misurato il 27/10), OnlyUp=false, e PropFirmMaxDailyDD=0 invece di 4: e l UNICO input cambiato rispetto alle corse di riferimento (21 mesi del 20/10: +59.796, 791 operazioni, DD equity 3.854; tre anni del 26/10). Serve a sapere se il limite giornaliero interno ha mai agito con lotti veri: se le operazioni escono identiche non ha mai agito. 4 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: 2013 ribasso, 2018 laterale, 2020 rialzo a Modello 1 (OHLC 1 minuto, pochi minuti ciascuna), poi UNA corsa continua a tick reali di 21 mesi (01/01/2025-01/10/2026, circa 3 ore: quella con il limite acceso ha richiesto 10.835 secondi). Timeout 420 minuti per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_REAPER_SENZALIMITE_<data> (o lo zip finale). Criteri e previsioni: report/REAPER_SENZA_LIMITE_GIORNALIERO_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Reaper nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_REAPER_SENZALIMITE_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_REAPER_SENZALIMITE_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Reaper deve essere gia installato')
open('righe/RIGA_LANCIA_REAPER_SENZA_LIMITE_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
