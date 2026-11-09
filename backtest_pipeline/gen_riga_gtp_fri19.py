#!/usr/bin/env python3
"""Riga unica O-2 per Gold Trade Pro: COMBO (Risk=3, MaxRiskPerStrategy 0.5, PropFirmMaxDailyDD 4.0) con FridayStopHour=19 (chiusura del venerdi), 80.000 EUR, XAUUSD D1, anni 2013, 2018, 2020, 2025, Modello 1, BCM, solo tester, 4 passate. Uso: python3 gen_riga_gtp_fri19.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/RIGA_LANCIA_GTP_COMBO_TRE_ANNI_80K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
IMPS = 'Risk=3:i;MaxRiskPerStrategy=0.5:d;PropFirmMaxDailyDD=4.0:d;FridayStopHour=19:i'
runs = [('Gold Trade Pro MT5.ex5', a, '1', 'D1', 'XAUUSD', IMPS, '', 'FRI19_GTP_COMBO_80000_' + a) for a in ('2013', '2018', '2020', '2025')]
N = len(runs)
q = lambda L: ','.join("'" + x + "'" for x in L)
assert all(re.fullmatch(r"[\x20-\x7E]*", x) for r in runs for x in r)
a = t.index('$fare=@('); b = t.index('$IMP=@{')
# la riga lunga di base ha gia queste matrici (ex5, anni, modello, periodo, simbolo, imposti, fine, etichetta)
old = t[a:b]
new = ("$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; ")
t = t[:a] + new + t[b:]
i = t.index("Write-Host 'GOLD TRADE PRO COMBO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("O-2 GOLD TRADE PRO: COSTO DELLA CHIUSURA DEL VENERDI. Gold Trade Pro COMBO (XAUUSD D1, Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0, gli stessi input del test a 80.000) con FridayStopHour=19 (ora del server: chiude le posizioni e non apre nuovi ordini dal venerdi 19:00) a DEPOSITO 80000 EUR (DEMO, SOLO TESTER, Modello 1), anni 2013, 2018, 2020, 2025: 4 passate (D1, pochi minuti ciascuna). Riferimento senza chiusura (FridayStopHour=25): test GTP_COMBO_TRE_ANNI gia fatto (netto 14.693 / 8.753 / 6.529 / 8.843, deterministico). Stessi criteri di O-2 di Reaper, Phantom e Goldbot (CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md, sezione O-2). Mi mandi la cartella ABTG_RISULTATI\\ANNO_ORO_GRADINI_GTPFRI19_<data>. Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("$TO=420;", "$TO=120;")
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO80K_WIM_TESTER.ps1'")
sost("$SH='D2AA1B85FBE16190EDC4F46BD7301D7EDA7CD7F576E5D798C57E8820121D4C1B'", "$SH='" + SHA + "'")
sost("$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'")
sost("$PIN='3e43646db065d2503f084f9e747b84bba9e1e97c'", "$PIN='" + PIN + "'")
sost("-Ex5Nome $n ", "-Ex5Nome $n -Deposito 80000 ", 2)
t = t.replace('ANNO80K_GTPCOMBO_ANNI_', 'ANNO_ORO_GRADINI_GTPFRI19_')
open('righe/RIGA_LANCIA_GTP_FRI19.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N)
