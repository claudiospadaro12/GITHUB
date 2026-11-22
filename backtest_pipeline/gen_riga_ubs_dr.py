#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [ ('UBS_LIBPACK_VOL_M15.zip', '2024', '2026.11.13', 'M15', 'US30_VOL_M15_g.set', 'U30USD_T', 'CLV_US30_g_L%s' % l) for l in ('0p1','1p5','3','5')]
assert len(FX) == 4
nuovo = ("ZNEW = 'UBS_LIBPACK_VOL_M15.zip'\n"
         "FX = " + repr(FX) + "\n"
         "LOTS = {'L0p1': '0.1', 'L1p5': '1.5', 'L3': '3', 'L5': '5'}\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag in FX:\n"
         "    for mod in ('4',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, 'Risk=0:i;StartLots=' + LOTS[tag.split('_')[-1]] + ':d;ForceSymbol=' + sym + ':s', 'UBSDR_%s_M%s_80000_%s' % (tag, mod, anno), 80000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 4")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_DR.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSDR_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS US30 VOLATILITY M15 (set g, futuro DowRaptor): 4 passate a tick reali (Modello 4) sul clone U30USD_T, dal 26/09/2024 al 13/11/2026, deposito 80000 EUR, lotto fisso 0,1 / 1,5 / 3 / 5 per MISURARE il drawdown massimo di equity a ogni taglia (profili PROP 3%, MEDIO 6%, ALTO 10%). Serve che i cloni (CLONA_INDICI e CLONA_TICK) siano gia a posto. Criteri: report/DOWRAPTOR_PROFILI_CRITERI_2026-11-22.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSDR_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 6 passate a tick reali su 3 mesi: pochi minuti ciascuna, stima 15-30 minuti; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_DR.txt'
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
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 80000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 6')

_t2 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=120;").replace("timeout 300 minuti", "timeout 120 minuti")
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')

_t6 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
_t6 = _t6.replace('100000 EUR', '80000 EUR')
assert '100000' not in _t6
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t6)
print('deposito 80000 ok')

# --- GUARDIA SELETTIVA (22/11): la riga convive con un'ottimizzazione nel portatile C:\MT5_BCM_Opt; conta solo i processi del terminale PRINCIPALE
import re as _re2
_t7 = open('righe/RIGA_LANCIA_UBS_DR.txt', encoding='ascii').read()
_pat = _re2.compile(r"@\(Get-Process -Name (terminal64,metaeditor64,metatester64|terminal64,metaeditor64) -ErrorAction SilentlyContinue\)")
_n = len(_pat.findall(_t7)); assert _n >= 4, _n
_t7 = _pat.sub(lambda m: "@(Get-Process -Name %s -ErrorAction SilentlyContinue | Where-Object { Mio $_ })" % m.group(1), _t7)
assert _t7.count("Get-Process -Name terminal64") == _t7.count("Where-Object { Mio $_ }")
assert _t7.count("ANNO80K_WIM_TESTER.ps1") == 1
_t7 = _t7.replace("ANNO80K_WIM_TESTER.ps1", "ANNO80K_WIM_TESTER_SEL.ps1")
_f = "function Mio($p){ (-not $p.Path) -or $p.Path.StartsWith('C:\\Program Files\\BCM Markets MT5 Terminal\\',[StringComparison]::OrdinalIgnoreCase) }; "
assert _t7.startswith("& { ")
_t7 = "& { " + _f + _t7[len("& { "):]
open('righe/RIGA_LANCIA_UBS_DR.txt', 'w', encoding='ascii').write(_t7)
print('guardia selettiva: sostituzioni', _n)
