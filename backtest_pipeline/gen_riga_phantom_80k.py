#!/usr/bin/env python3
"""Riga unica: The Gold Phantom (Profalgo, XAUUSD H1) con i set del venditore (cambiano MaxAllowedDD, OnlyUp, PropFirmMaxDailyDD) sui tre anni 2013/2018/2020 e 2025 a Modello 1, poi UNA corsa a tick reali di 21 mesi col set prop. 80.000 EUR. Uso: python3 gen_riga_phantom_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'The Gold Phantom.ex5'
# (nome, etichetta, MaxAllowedDD, OnlyUp, PropFirmMaxDailyDD): dai set .set del venditore; Randomization 0 imposta (nei set prop e 50: serve a rendere diversi i conti, qui renderebbe la corsa non ripetibile)
SETS = [('PROPFIRM', 'D9', '9.0', 'false', '4.0'), ('PROPCOMBO', 'D4', '4.0', 'false', '4.0'), ('LOWRISK', 'D10', '10.0', 'true', '0.0'), ('MEDIUM', 'D30', '30.0', 'true', '0.0'), ('HIGHRISK', 'D60', '60.0', 'true', '0.0')]
def imp(m, ou, dd): return 'TradeFrequency=5:i;MaxAllowedDD=%s:d;OnlyUp=%s:b;PropFirmMaxDailyDD=%s:d;Randomization=0.0:d' % (m, ou, dd)
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for nome, e, m, ou, dd in SETS: runs.append((EX, anno, '1', 'H1', 'XAUUSD', imp(m, ou, dd), '', '%s_M1_PHANTOM_%s_%s' % (anno, nome, e)))
nome, e, m, ou, dd = SETS[0]; runs.append((EX, '2025', '4', 'H1', 'XAUUSD', imp(m, ou, dd), '2026.10.01', '2025_M4_PHANTOM_%s_%s' % (nome, e)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("THE GOLD PHANTOM CON I SET DEL VENDITORE NEI TRE MERCATI (80.000 EUR, DEMO, SOLO TESTER): XAUUSD H1 (come dice la pagina del Market), 9 strategie su H1, H4 e D1. Dei 7 file .set del venditore la riga usa 5: prop firm (MaxAllowedDD 9, OnlyUp spento, limite giornaliero 4), prop combo (MaxAllowedDD 4), low risk (10), medium (30) e high (60); restano fuori combo (7) e il set del conto live del venditore (30 con TradeFrequency 3). Cambiano solo MaxAllowedDD, OnlyUp e PropFirmMaxDailyDD; TradeFrequency e 5 (auto) in tutti. Randomization e imposta a 0 (nei set prop e 50): dichiarato. ATTENZIONE: in questo EA MaxAllowedDD decide anche il lotto (parole del venditore) e con TradeFrequency auto la frequenza dipende da saldo e MaxAllowedDD: a 80.000 EUR puo girare piu strategie che nelle tranche da 5.000 del 19/10. 21 PASSATE a conto vuoto da 80000 EUR, ordinate DAL PIU CORTO AL PIU LUNGO: prima 20 passate a Modello 1 (OHLC 1 minuto) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno dei 5 set; poi UNA corsa continua a tick reali di 21 mesi (01/01/2025-01/10/2026) col set prop firm (calibrazione del Modello 1 per quel set e prova lunga). Tempo: NON misurato con questi set; le tranche da 5.000 a tick reali richiedevano circa 9 minuti al mese: atteso circa 3-4 ore per la corsa lunga e alcune ore per le 20 a Modello 1, in tutto da 5 a 8 ore; timeout 420 minuti per passata. Se un set manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_PHANTOM_<data> (o lo zip finale). Criteri e previsioni: report/GOLD_PHANTOM_SET_TRE_ANNI_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca The Gold Phantom nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_PHANTOM_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_PHANTOM_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'The Gold Phantom deve essere gia installato')
open('righe/RIGA_LANCIA_PHANTOM_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
