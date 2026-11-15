#!/usr/bin/env python3
"""[SCALPER CLAUDIO 1.03] derivata da gen_riga_d160_gtp.py (riga con input, senza set e senza zip). Prova di ABTG_ScalperClaudio.ex5 (mql5/Experts/ABTG_ScalperClaudio.mq5, versione 1.02) a TICK REALI (Modello 4), XAUUSD, deposito 10000 EUR: 5 varianti sul primo trimestre 2025 (A base, B lotto fisso, C uscita a cesto, D senza recupero a zero, E piramide anche nel cesto) + la variante A sul primo trimestre 2026. 6 passate.
Criteri: report/EA_SOLO_POSITIVE_ACCELERAZIONE_CRITERI_2026-11-14.md. Uso: python3 gen_riga_scalper_claudio.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/RIGA_LANCIA_GTP_COMBO_TRE_ANNI_80K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
EA = 'ABTG_ScalperClaudio.ex5'
def imps(exit_mode, lot_mode, rec):
    return ';'.join(['InpLookbackSec=2:i', 'InpMinMovePoints=3.0:d', 'InpPointsPerOrder=3.0:d', 'InpMaxOpen=8:i', 'InpLot=0.01:d', 'InpMaxTotalLots=0.2:d',
                     'InpGapMaxPoints=10.0:d', 'InpStepPauseMs=1000:i', 'InpMaxSpreadPoints=0:i', 'InpLotMode=%d:i' % lot_mode, 'InpLotStepEuro=10.0:d', 'InpLotStep=0.01:d', 'InpLotMax=0.05:d',
                     'InpExitMode=%d:i' % exit_mode, 'InpTargetEuro=1.5:d', 'InpBasketTargetEuro=2.0:d', 'InpRecoveryToZero=%s:b' % ('true' if rec else 'false'), 'InpUnderwaterEuro=3.0:d', 'InpZeroEuro=0.0:d',
                     'InpBasketStopEuro=20.0:d', 'InpCooldownMin=30:i', 'InpMaxRequestsPerDay=0:i', 'InpStartHour=0:i', 'InpEndHour=24:i', 'InpSignalCheckSec=10:i', 'InpWriteCsv=false:b', 'InpVerbose=false:b', 'InpDailyTargetEuro=0.0:d', 'InpDailyLossEuro=0.0:d'])
runs = [  # (ex5, anno, modello, periodo, simbolo, imposti, fine, etichetta)
 (EA, '2025', '4', 'M1', 'XAUUSD', imps(0, 1, True), '2025.07.01', 'SC103_A_2025H1'),
 (EA, '2025', '4', 'M1', 'XAUUSD', imps(0, 1, True), '2026.01.01', 'SC103_B_2025ANNO'),
]
N = len(runs)
assert N == 2
q = lambda L: ','.join("'" + x + "'" for x in L)
assert all(re.fullmatch(r"[\x20-\x7E]*", x) for r in runs for x in r)
a = t.index('$fare=@('); b = t.index('$IMP=@{')
new = ("$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $FINR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $vi=0; ")
t = t[:a] + new + t[b:]
i = t.index("Write-Host 'GOLD TRADE PRO COMBO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("SCALPER CLAUDIO 1.03: misura del vantaggio a TICK REALI. ABTG_ScalperClaudio.ex5 versione 1.03 (correzioni + righe EDGE), XAUUSD, DEMO, SOLO TESTER, Modello 4 (tick reali), deposito 10000 EUR, input come la 1.02 (base). DUE passate: A = 01/01/2025 -> 01/07/2025 (periodo di ricerca) e B = anno 2025 intero (il periodo di conferma luglio-dicembre si ricava per differenza dalle somme stampate). Criteri e previsioni scritti prima: report/ABTG_SCALPER_CLAUDIO_V103_CRITERI_2026-11-15.md. Mi mandi lo zip ANNO_ORO_GRADINI_SCALPER103_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("PRIMA DI LANCIARE: Gold Trade Pro deve essere gia installato (demo del Market) su QUESTO terminale; NON attaccarli a nessun grafico.",
     "PRIMA DI LANCIARE: ABTG_ScalperClaudio.ex5 versione 1.03 compilato (F7) in MQL5\\\\Experts, UNA copia; nessun EA sui grafici.")
sost("TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per",
     "TEMPO: la 1.02 ha impiegato 58 secondi per un trimestre: stima 2-6 minuti per passata, NON MISURATO su 6-12 mesi; se la PRIMA passata non finisce in 60 minuti avvisami. Timeout 300 minuti per")
sost("$TO=420;", "$TO=300;")
sost("'MQL5\\Experts\\Market'", "'MQL5\\Experts'")
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO80K_WIM_TESTER.ps1'")
sost("$SH='D2AA1B85FBE16190EDC4F46BD7301D7EDA7CD7F576E5D798C57E8820121D4C1B'", "$SH='" + SHA + "'")
sost("$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'")
sost("$PIN='3e43646db065d2503f084f9e747b84bba9e1e97c'", "$PIN='" + PIN + "'")
sost("-Ex5Nome $n ", "-Ex5Nome $n -Deposito 10000 ", 2)
t = re.sub(r"if\(\$okl\.Count -lt 1\)\{ throw '[^']*' \}", lambda m: "if($okl.Count -lt 1){ throw 'Manca ABTG_ScalperClaudio.ex5 in MQL5\\Experts di questo terminale (compilalo con MetaEditor, F7). Nessun tester e partito.' }", t, count=1)
t = t.replace("EA .ex5 trovati nel Market di questo terminale", "EA .ex5 trovati in MQL5\\Experts di questo terminale").replace("MANCA nel Market di questo terminale, SALTO", "MANCA in MQL5\\Experts di questo terminale, SALTO")
t = t.replace('ANNO80K_GTPCOMBO_ANNI_', 'ANNO_ORO_GRADINI_SCALPER103_')
t = t.replace('80.000 EUR', '10.000 EUR').replace('80000 EUR', '10000 EUR')
open('righe/RIGA_LANCIA_SCALPER_103.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N)
