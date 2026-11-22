#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [ ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_minSize_m', ';minSize=9500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_minSize_p', ';minSize=10500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_AtrPeriod_m', ';AtrPeriod=32:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_AtrPeriod_p', ';AtrPeriod=34:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_DevFactor_m', ';DevFactor=2.0:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_DevFactor_p', ';DevFactor=2.2:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_stop_m', ';Exit_stop=71000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_stop_p', ';Exit_stop=75000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_limit_m', ';Exit_limit=37000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_limit_p', ';Exit_limit=41000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailSL_size_m', ';Exit_TrailSL_size=3500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailSL_size_p', ';Exit_TrailSL_size=4500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailSL_Start_p', ';Exit_TrailSL_Start=2500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailTP_size_m', ';Exit_TrailTP_size=58000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailTP_size_p', ';Exit_TrailTP_size=62000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailTP_Start_m', ';Exit_TrailTP_Start=62000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'PT_g_TrailTP_Start_p', ';Exit_TrailTP_Start=66000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_minSize_m', ';minSize=3000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_minSize_p', ';minSize=4000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_AtrPeriod_m', ';AtrPeriod=37:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_AtrPeriod_p', ';AtrPeriod=39:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_DevFactor_m', ';DevFactor=2.2:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_DevFactor_p', ';DevFactor=2.4:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_stop_m', ';Exit_stop=35000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_stop_p', ';Exit_stop=39000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_limit_m', ';Exit_limit=9000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_limit_p', ';Exit_limit=13000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailSL_size_m', ';Exit_TrailSL_size=2500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailSL_size_p', ';Exit_TrailSL_size=3500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailSL_Start_p', ';Exit_TrailSL_Start=2500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailTP_size_m', ';Exit_TrailTP_size=16000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailTP_size_p', ';Exit_TrailTP_size=20000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailTP_Start_m', ';Exit_TrailTP_Start=78000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_c.set', 'U30USD_T', 'PT_c_TrailTP_Start_p', ';Exit_TrailTP_Start=82000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_minSize_m', ';minSize=11500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_minSize_p', ';minSize=12500:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_AtrPeriod_m', ';AtrPeriod=48:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_AtrPeriod_p', ';AtrPeriod=50:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_DevFactor_m', ';DevFactor=1.9:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_DevFactor_p', ';DevFactor=2.1:d'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_stop_m', ';Exit_stop=59000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_stop_p', ';Exit_stop=63000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_limit_m', ';Exit_limit=9000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_limit_p', ';Exit_limit=13000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailSL_size_m', ';Exit_TrailSL_size=16000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailSL_size_p', ';Exit_TrailSL_size=17000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailSL_Start_m', ';Exit_TrailSL_Start=2000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailSL_Start_p', ';Exit_TrailSL_Start=3000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailTP_size_p', ';Exit_TrailTP_size=4000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailTP_Start_m', ';Exit_TrailTP_Start=70000:i'),
 ('UBS_LIBPACK_VOL_M15.zip', '2025', '2026.11.13', 'M15', 'US30_VOL_M15_a.set', 'U30USD_T', 'PT_a_TrailTP_Start_p', ';Exit_TrailTP_Start=74000:i'),
]
assert len(FX) == 51
nuovo = ("ZNEW = 'UBS_LIBPACK_VOL_M15.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag, extra in FX:\n"
         "    for mod in ('4',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, IMPFX + ';ForceSymbol=' + sym + ':s' + extra, 'UBSPT_%s_M%s_100000_%s' % (tag, mod, anno), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 51")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_PT.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSPT_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS US30 VOLATILITY M15, PERTURBAZIONE DEI PARAMETRI (passo 4 della guida di Wim): per i set VOL_M15_g (vincolante), c e a (informative) ogni parametro libero spostato di un passo in meno e in piu, sul clone U30USD_T a tick reali (Modello 4), 01/01/2025 - 13/11/2026, lotto 0,1, deposito 100000 EUR: 51 passate. Soglia: almeno il 70% delle varianti con PF > 1,0. Criteri: report/UBS_PERTURBAZIONE_CRITERI_2026-11-22.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSPT_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 51 passate a tick reali (circa 4 minuti ciascuna dalla misura del 22/11): stima 3-4 ore; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_PT.txt'
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
_t = _t.replace('DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip)', 'zip dei set (UBS_LIBPACK_VOL_M15.zip, creato da ESTRAI_SET_VOL_M15 sul Desktop)')
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 100000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 51')

_t2 = open('righe/RIGA_LANCIA_UBS_PT.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_PT.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_PT.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_PT.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_PT.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_PT.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_PT.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=60;").replace("timeout 300 minuti", "timeout 60 minuti")
open('righe/RIGA_LANCIA_UBS_PT.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')
