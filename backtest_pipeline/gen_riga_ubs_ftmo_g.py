#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [ ('UBS_LIBPACK_VOL_M15.zip', str(y), (str(y+1)+'.01.01' if y<2026 else '2026.11.14'), 'M15', 'US30_VOL_M15_g.set', 'US30.cash', 'FTG_%d' % y) for y in range(2020,2027)]
assert len(FX) == 7
nuovo = ("ZNEW = 'UBS_LIBPACK_VOL_M15.zip'\n"
         "FX = " + repr(FX) + "\n"
         "LOTS = {'L0p1': '0.1', 'L1p5': '1.5', 'L3': '3', 'L5': '5'}\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, 'Risk=0:i;StartLots=' + '0.1' + ':d;ForceSymbol=' + sym + ':s', 'UBSFG_%s_M%s_80000_%s' % (tag, mod, anno), 80000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 7")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_FG.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSFG_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS US30 VOLATILITY M15, set g di Wim sul FEED FTMO (US30.cash, terminale di PROVA FTMO in sola lettura), anno per anno 2020-2026, Modello 1 (barre da 1 minuto), deposito 80000 EUR, lotto fisso 0,1 (Risk=0): 7 passate per sapere se il vantaggio di g (PF 2,0 su BCM, 26 mesi) e stabile su 7 anni. Criteri: report/UBS_G_FTMO_CRITERI_2026-11-22.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSFG_<data>. L EA Ultimate_Breakout_EA_WSC_V9.5.ex5 deve stare in MQL5/Experts/WIM del terminale FTMO. Terminale FTMO CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 6 passate a tick reali su 3 mesi: pochi minuti ciascuna, stima 15-30 minuti; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_FG.txt'
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

_t2 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=120;").replace("timeout 300 minuti", "timeout 120 minuti")
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')

_t6 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
_t6 = _t6.replace('100000 EUR', '80000 EUR')
assert '100000' not in _t6
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t6)
print('deposito 80000 ok')

# --- GUARDIA SELETTIVA (22/11): la riga convive con un'ottimizzazione nel portatile C:\MT5_BCM_Opt; conta solo i processi del terminale PRINCIPALE
import re as _re2
_t7 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
_pat = _re2.compile(r"@\(Get-Process -Name (terminal64,metaeditor64,metatester64|terminal64,metaeditor64) -ErrorAction SilentlyContinue\)")
_n = len(_pat.findall(_t7)); assert _n >= 4, _n
_t7 = _pat.sub(lambda m: "@(Get-Process -Name %s -ErrorAction SilentlyContinue | Where-Object { Mio $_ })" % m.group(1), _t7)
assert _t7.count("Get-Process -Name terminal64") == _t7.count("Where-Object { Mio $_ }")
assert _t7.count("ANNO80K_WIM_TESTER.ps1") == 1
_t7 = _t7.replace("ANNO80K_WIM_TESTER.ps1", "ANNO80K_WIM_FTMO_TESTER_SEL.ps1")
_f = "function Mio($p){ (-not $p.Path) -or $p.Path.StartsWith('C:\\MT5_Backtest\\Mt5_Ftmo_Prova\\',[StringComparison]::OrdinalIgnoreCase) }; "
assert _t7.startswith("& { ")
_t7 = "& { " + _f + _t7[len("& { "):]
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t7)
print('guardia selettiva: sostituzioni', _n)


# --- FTMO: bersaglio e marcatore (come gen_riga_btc_ftmo_80k.py)
_t8 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
def _S(a, b, n=1):
    global _t8
    assert _t8.count(a) == n, (_t8.count(a), a[:90])
    _t8 = _t8.replace(a, b)
_S("terminale C:\Program Files\BCM Markets MT5 Terminal (cartella BCM Markets MT5 Terminal), loggato sul demo 50503392 di QUESTO PC.",
   "terminale C:\MT5_Backtest\Mt5_Ftmo_Prova (FTMO-Demo, in SOLA LETTURA con password investitore: NON puo aprire ordini; e lo stesso conto delle sedie sul VPS, che NON viene toccato).")
_S("chiudi A MANO SOLO il terminal64 con cartella C:\Program Files\BCM Markets MT5 Terminal. Qui ci sono TRE MT5 (C:\Program Files\BCM Markets MT5 Terminal = demo 50503392, C:\MT5_Backtest, C:\FundedNext_Manuale): devono essere tutti chiusi.",
   "chiudi A MANO SOLO il terminal64 con cartella C:\MT5_Backtest\Mt5_Ftmo_Prova. Gli altri MT5 (per esempio l ottimizzazione nel portatile C:\MT5_BCM_Opt) possono restare aperti.")
_S("($inst='C:\Program Files\BCM Markets MT5 Terminal'))){ throw 'il terminale BCM del PC di backtest non e dove la riga lo aspetta", "($inst='C:\MT5_Backtest\Mt5_Ftmo_Prova'))){ throw 'il terminale C:\MT5_Backtest\Mt5_Ftmo_Prova non e dove la riga lo aspetta")
_S("terminal64 con cartella C:\Program Files\BCM Markets MT5 Terminal.' -ForegroundColor Red; $rest","terminal64 con cartella C:\MT5_Backtest\Mt5_Ftmo_Prova.' -ForegroundColor Red; $rest")
_t8 = _t8.replace("MARCATORE_ANNO80K_WIM_TESTER_v1", "MARCATORE_ANNO80K_WIM_FTMO_TESTER_v1")
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t8)
print('FTMO ok', len(_t8))

_t9 = open('righe/RIGA_LANCIA_UBS_FG.txt', encoding='ascii').read()
_a = "chiudi A MANO il terminale BCM (Task Manager > Dettagli > terminal64.exe di C:\\\\Program Files\\\\BCM Markets MT5 Terminal, SOLO quello)"
assert _t9.count(_a) == 1, _t9.count(_a)
_t9 = _t9.replace(_a, "chiudi A MANO il terminale FTMO di prova (Task Manager > Dettagli > terminal64.exe di C:\\\\MT5_Backtest\\\\Mt5_Ftmo_Prova, SOLO quello)")
assert "Program Files" not in _t9
open('righe/RIGA_LANCIA_UBS_FG.txt', 'w', encoding='ascii').write(_t9)
print('testo FTMO ok')
