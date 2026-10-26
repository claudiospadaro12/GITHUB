#!/usr/bin/env python3
"""Riga unica: My AI Gold con gli 8 set del venditore (cambia solo `balance`) su 2013/2018/2020/2025 a Modello 1 (le piu corte prima) e 2025 a tick reali (calibrazione), 80.000 EUR, XAUUSD H1. Uso: python3 gen_riga_myai_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
EX = 'My AI Gold.ex5'
SETS = [('AGGRESSIVE', '100', ''), ('HIGHRISK', '250', ''), ('NORMAL', '500', ''), ('LOWRISK', '750', ''), ('CONSERVATIVE', '1000', ''), ('PROPFTMO', '1500', ''), ('GUIDA2000', '2000', ''),
        ('PROPX9', '2500', ';FrHour=22:i;NewsFilter=true:b;DontOpBef=60:i;DontOpAft=60:i')]
# input dei set che esistono nella versione installata e valgono il default: si impone SOLO balance (gli altri sono verificati uguali al default dal confronto set-default); MaxCountOrders non esiste nella versione installata
runs = []
for anno in ('2013', '2018', '2020', '2025'):
    for nome, bal, ext in SETS: runs.append((EX, anno, '1', 'H1', 'XAUUSD', 'balance=%s:d%s' % (bal, ext), '%s_M1_MYAI_%s_B%s' % (anno, nome, bal)))
for nome, bal, ext in SETS: runs.append((EX, '2025', '4', 'H1', 'XAUUSD', 'balance=%s:d%s' % (bal, ext), '2025_M4_MYAI_%s_B%s' % (nome, bal)))
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("MY AI GOLD CON I SET DEL VENDITORE NEI TRE MERCATI (80.000 EUR, DEMO, SOLO TESTER): i primi 6 file .set (aggressive, highrisk, normalrisk, lowrisk, conservative, prop FTMO) differiscono SOLO per il valore di balance (100, 250, 500, 750, 1000, 1500: il lotto e circa 0,01 ogni balance di saldo, quindi a 80.000 EUR da 0,53 a 8 lotti), quindi si impone solo balance. Aggiunti: GUIDA2000 (balance 2000 = Balance Step di riferimento della guida) e PROPX9 (nuovo set prop: balance 2500, FrHour 22, filtro news acceso 60/60; il suo MaxCountOrders=1 NON esiste nella versione installata e non e imponibile; il calendario news nel tester probabilmente non funziona, quindi PROPX9 e di fatto balance 2500 con chiusura venerdi alle 22). Resta il default Recovery=true (recupero attivo: classe di rischio a parte) e AutoGMT=true (nessun offset impostabile: orologio NON verificato su BCM). 40 PASSATE a conto vuoto da 80000 EUR, XAUUSD H1, ordinate DAL PIU CORTO AL PIU LUNGO: prima 32 passate a Modello 1 (OHLC 1 minuto) sui tre anni 2013 ribasso, 2018 laterale, 2020 rialzo e sul 2025, per ognuno degli 8 set; poi 8 passate del 2025 a TICK REALI (calibrazione del Modello 1). Tempo: NON misurato su questo EA (due mesi a tick reali hanno richiesto circa 1 minuto): atteso da 1 a 4 ore in tutto; timeout 240 minuti per passata. Se un set manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_MYAI_<data> (o lo zip finale). Criteri e previsioni: report/MY_AI_GOLD_SET_TRE_ANNI_CRITERI_2026-10-26.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $ETI=@(" + q([r[6] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 1){ throw 'Manca My AI Gold.ex5 nel Market di questo terminale. Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi];")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_MYAI_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_MYAI_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'My AI Gold deve essere gia installato')
open('righe/RIGA_LANCIA_MYAI_GOLD_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
