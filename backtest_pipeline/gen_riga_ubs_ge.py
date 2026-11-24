#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
IMP = {'GTPD1_01': 'ST1_HL_strength_L=17:i;ST1_HL_strength_R=7:i;ST1_countback=150:i;ST1_MinDist_to_HL=650:d;ST1_UpDiff=10:d;ST1_DownDiff=0:d;MaxTrades=4:i;MinDist_orders=530:d;ST1_Expiration_hours=432:i;Exit_stop=4600:d;Exit_limit=4300:d;Exit_TrailSL_size=0:d;Exit_TrailSL_Start=1000:d;Exit_TrailSL_Stop=2200:d;Exit_TrailTP_size=90:d;Exit_TrailTP_Start=170:d', 'GTPD1_02': 'ST1_HL_strength_L=15:i;ST1_HL_strength_R=13:i;ST1_countback=190:i;ST1_MinDist_to_HL=600:d;ST1_UpDiff=-150:d;ST1_DownDiff=150:d;MaxTrades=4:i;MinDist_orders=30:d;ST1_Expiration_hours=480:i;Exit_stop=3500:d;Exit_limit=3800:d;Exit_TrailSL_size=950:d;Exit_TrailSL_Start=50:d;Exit_TrailSL_Stop=200:d;Exit_TrailTP_size=0:d;Exit_TrailTP_Start=85:d', 'GTPD1_03': 'ST1_HL_strength_L=15:i;ST1_HL_strength_R=13:i;ST1_countback=190:i;ST1_MinDist_to_HL=600:d;ST1_UpDiff=-150:d;ST1_DownDiff=150:d;MaxTrades=2:i;MinDist_orders=30:d;ST1_Expiration_hours=432:i;Exit_stop=4700:d;Exit_limit=3800:d;Exit_TrailSL_size=950:d;Exit_TrailSL_Start=50:d;Exit_TrailSL_Stop=200:d;Exit_TrailTP_size=0:d;Exit_TrailTP_Start=0:d', 'GTPD1_04': 'ST1_HL_strength_L=15:i;ST1_HL_strength_R=10:i;ST1_countback=190:i;ST1_MinDist_to_HL=600:d;ST1_UpDiff=180:d;ST1_DownDiff=60:d;MaxTrades=5:i;MinDist_orders=580:d;ST1_Expiration_hours=408:i;Exit_stop=4700:d;Exit_limit=3800:d;Exit_TrailSL_size=950:d;Exit_TrailSL_Start=50:d;Exit_TrailSL_Stop=200:d;Exit_TrailTP_size=15:d;Exit_TrailTP_Start=135:d', 'GTPD1_05': 'ST1_HL_strength_L=3:i;ST1_HL_strength_R=2:i;ST1_countback=20:i;ST1_MinDist_to_HL=100:d;ST1_UpDiff=-290:d;ST1_DownDiff=-90:d;MaxTrades=1:i;MinDist_orders=30:d;ST1_Expiration_hours=24:i;Exit_stop=300:d;Exit_limit=1000:d;Exit_TrailSL_size=550:d;Exit_TrailSL_Start=100:d;Exit_TrailSL_Stop=5000:d;Exit_TrailTP_size=135:d;Exit_TrailTP_Start=200:d', 'GTPD1_06': 'ST1_HL_strength_L=3:i;ST1_HL_strength_R=2:i;ST1_countback=20:i;ST1_MinDist_to_HL=1700:d;ST1_UpDiff=0:d;ST1_DownDiff=-190:d;MaxTrades=1:i;MinDist_orders=30:d;ST1_Expiration_hours=24:i;Exit_stop=1900:d;Exit_limit=3300:d;Exit_TrailSL_size=200:d;Exit_TrailSL_Start=0:d;Exit_TrailSL_Stop=200:d;Exit_TrailTP_size=0:d;Exit_TrailTP_Start=0:d', 'GTPD1_07': 'ST1_HL_strength_L=5:i;ST1_HL_strength_R=20:i;ST1_countback=230:i;ST1_MinDist_to_HL=1950:d;ST1_UpDiff=-200:d;ST1_DownDiff=280:d;MaxTrades=5:i;MinDist_orders=80:d;ST1_Expiration_hours=480:i;Exit_stop=1300:d;Exit_limit=4800:d;Exit_TrailSL_size=250:d;Exit_TrailSL_Start=450:d;Exit_TrailSL_Stop=4600:d;Exit_TrailTP_size=175:d;Exit_TrailTP_Start=10:d', 'GTPD1_08': 'ST1_HL_strength_L=8:i;ST1_HL_strength_R=2:i;ST1_countback=170:i;ST1_MinDist_to_HL=550:d;ST1_UpDiff=-270:d;ST1_DownDiff=80:d;MaxTrades=3:i;MinDist_orders=130:d;ST1_Expiration_hours=48:i;Exit_stop=3800:d;Exit_limit=1700:d;Exit_TrailSL_size=600:d;Exit_TrailSL_Start=1000:d;Exit_TrailSL_Stop=3400:d;Exit_TrailTP_size=200:d;Exit_TrailTP_Start=140:d', 'GTPD1_09': 'ST1_HL_strength_L=7:i;ST1_HL_strength_R=8:i;ST1_countback=40:i;ST1_MinDist_to_HL=150:d;ST1_UpDiff=100:d;ST1_DownDiff=-20:d;MaxTrades=3:i;MinDist_orders=530:d;ST1_Expiration_hours=24:i;Exit_stop=3700:d;Exit_limit=1600:d;Exit_TrailSL_size=550:d;Exit_TrailSL_Start=350:d;Exit_TrailSL_Stop=400:d;Exit_TrailTP_size=5:d;Exit_TrailTP_Start=135:d', 'GTPD1_10': 'ST1_HL_strength_L=8:i;ST1_HL_strength_R=12:i;ST1_countback=100:i;ST1_MinDist_to_HL=950:d;ST1_UpDiff=-130:d;ST1_DownDiff=180:d;MaxTrades=3:i;MinDist_orders=430:d;ST1_Expiration_hours=432:i;Exit_stop=3300:d;Exit_limit=1100:d;Exit_TrailSL_size=1000:d;Exit_TrailSL_Start=950:d;Exit_TrailSL_Stop=400:d;Exit_TrailTP_size=115:d;Exit_TrailTP_Start=100:d'}
FX = [ ('UBS_GTPD1_SET.zip', '2023', '2026.11.01', 'D1', 'optimization_gold.set', 'XAUUSD', t) for t in sorted(IMP)]
assert len(FX) == 10
nuovo = ("IMP = " + repr(IMP) + "\n"
         "ZNEW = 'UBS_GTPD1_SET.zip'\n"
         "FX = " + repr(FX) + "\n"
         "LOTS = {}\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, 'Risk=0:i;StartLots=0.1:d;ForceSymbol=' + sym + ':s;' + IMP[tag], 'UBSGE_%s_M%s_100000_%s' % (tag, mod, anno), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 10")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_GE.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSGE_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS GOLD TRADE PRO (GTP) ORO D1, PROVA V2 DOPO L OTTIMIZZAZIONE: 10 candidati dell ottimizzazione 2013-2022 provati SENZA ottimizzare su XAUUSD D1 dal 01/01/2023 al 31/10/2026, Modello 1, deposito 100000 EUR, lotto fisso 0,1 (EA Ultimate_Breakout_EA_WSC_V9.5, set optimization_gold.set di Wim con i 16 parametri del candidato). Cancello V2 per candidato: PF >= 1,20, profitto > 0, operazioni >= 20, anni non negativi >= 60%. Criteri e previsioni: report/GTP_D1_V2_CRITERI_2026-11-24.md. Serve UBS_GTPD1_SET.zip sul Desktop. Mi mandi lo zip ANNO_ORO_GRADINI_UBSGE_<data>. Il terminale PRINCIPALE BCM CHIUSO (il portatile C:\\MT5_BCM_Opt con l ottimizzazione puo restare aperto). EA e set di Wim: ricerca, fuori dal progetto prop. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 10 passate D1 su 9 anni a barre da 1 minuto: pochi minuti ciascuna, stima 1-2 ore con l ottimizzazione in corso; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_GE.txt'
_t = open(_p, encoding='ascii').read()
def P(a_, b_, n=1):
    global _t
    assert _t.count(a_) == n, (_t.count(a_), a_[:90])
    _t = _t.replace(a_, b_)
P("if($zpath.Count -lt 1){ Write-Host 'MI FERMO: Ultimate-Breakout-System-Set-Files.zip non si trova sul Desktop, in Download o in Documenti di questo PC. Mettilo li (e un file di Wim, lo stesso che mi hai mandato) e rilancia. Nessun tester e partito.' -ForegroundColor Red; return }; ",
  "if($zpath.Count -lt @($ZIPR | Select-Object -Unique).Count){ Write-Host 'MI FERMO: manca almeno uno dei DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip) sul Desktop, in Download o in Documenti di questo PC. Mettili li (file di Wim, gli stessi che mi hai mandato) e rilancia. Nessun tester e partito.' -ForegroundColor Red; return }; ")
P("foreach($sn in @($SETR | Select-Object -Unique)){ $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[0]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $sn }); if($gg.Count -ne 1){ Write-Host ('MI FERMO: nel pacchetto il set ' + $sn + ' risulta ' + $gg.Count + ' volte (ne serve UNA). Nessun tester e partito.') -ForegroundColor Red; return } }; ",
  "for($k=0; $k -lt $SETR.Count; $k++){ $sn=$SETR[$k]; $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[$k]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName.EndsWith('\\' + $sn) }); if($gg.Count -ne 1){ Write-Host ('MI FERMO: nel pacchetto ' + $ZIPR[$k] + ' il set ' + $sn + ' risulta ' + $gg.Count + ' volte (ne serve UNA). Nessun tester e partito.') -ForegroundColor Red; return } }; ")
P("Where-Object { $_.Name -eq $SETR[$vi] }", "Where-Object { $_.FullName.EndsWith('\\' + $SETR[$vi]) }")
_t = _t.replace('DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip)', 'zip dei set (UBS_GTPD1_SET.zip sul Desktop)')
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 80000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 6')

_t2 = open('righe/RIGA_LANCIA_UBS_GE.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_GE.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_GE.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_GE.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_GE.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_GE.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_GE.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=120;").replace("timeout 300 minuti", "timeout 120 minuti")
open('righe/RIGA_LANCIA_UBS_GE.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')

print('deposito 100000 mantenuto')

# --- GUARDIA SELETTIVA (22/11): la riga convive con un'ottimizzazione nel portatile C:\MT5_BCM_Opt; conta solo i processi del terminale PRINCIPALE
import re as _re2
_t7 = open('righe/RIGA_LANCIA_UBS_GE.txt', encoding='ascii').read()
_pat = _re2.compile(r"@\(Get-Process -Name (terminal64,metaeditor64,metatester64|terminal64,metaeditor64) -ErrorAction SilentlyContinue\)")
_n = len(_pat.findall(_t7)); assert _n >= 4, _n
_t7 = _pat.sub(lambda m: "@(Get-Process -Name %s -ErrorAction SilentlyContinue | Where-Object { Mio $_ })" % m.group(1), _t7)
assert _t7.count("Get-Process -Name terminal64") == _t7.count("Where-Object { Mio $_ }")
assert _t7.count("ANNO80K_WIM_TESTER.ps1") == 1
_t7 = _t7.replace("ANNO80K_WIM_TESTER.ps1", "ANNO80K_WIM_TESTER_SEL.ps1")
_f = "function Mio($p){ (-not $p.Path) -or $p.Path.StartsWith('C:\\Program Files\\BCM Markets MT5 Terminal\\',[StringComparison]::OrdinalIgnoreCase) }; "
assert _t7.startswith("& { ")
_t7 = "& { " + _f + _t7[len("& { "):]
open('righe/RIGA_LANCIA_UBS_GE.txt', 'w', encoding='ascii').write(_t7)
print('guardia selettiva: sostituzioni', _n)
