#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [  # 17 set: i 7 del cancello M1 + CLI_HJP09/10 + 6 volatility breakout + OTH_GU_a + OTH_EU_b (HANG1/HANG4 e OTH_EU_a esclusi: lotto da rischio / P2 in perdita)
 ('9637033_Till_UBS-US30-M15-U3V12.set','M15','U30USD','VM15_US30_U3V12'),
 ('UBS-US30-M15-U3V08.set','M15','U30USD','VM15_US30_U3V08'),
 ('US30_VOL_M15_a.set','M15','U30USD','VM15_US30_a'),
 ('US30_VOL_M15_b.set','M15','U30USD','VM15_US30_b'),
 ('US30_VOL_M15_c.set','M15','U30USD','VM15_US30_c'),
 ('US30_VOL_M15_g.set','M15','U30USD','VM15_US30_g'),
 ('UBS-US500-M15-U5W10.set','M15','SPXUSD','VM15_SPX_U5W10'),
 ('VolUS500_a.set','M15','SPXUSD','VM15_SPX_a'),
 ('VolUS500_c.set','M15','SPXUSD','VM15_SPX_c'),
 ('VolUS500_g.set','M15','SPXUSD','VM15_SPX_g'),
 ('NAS_VOL_M15_A.set','M15','NASUSD','VM15_NAS_A'),
 ('NAS_VOL_M15_B.set','M15','NASUSD','VM15_NAS_B'),
 ('NAS_VOL_M15_C.set','M15','NASUSD','VM15_NAS_C'),
 ('NAS_VOL_M15_D.set','M15','NASUSD','VM15_NAS_D'),
 ('NAS_VOL_M15_E.set','M15','NASUSD','VM15_NAS_E'),
]
assert len(FX) == 15
nuovo = ("ZNEW = 'UBS_LIBPACK_VOL_M15.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []; MODS = []\n"
         "for rel, per, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, ZNEW, '2025', '2026.11.13', per, rel, IMPFX + ';ForceSymbol=' + sym + ':s', 'UBSVM15M1_%s_M%s_100000_2025-2026' % (tag, mod), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 15")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_VM15M1.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSVM15M1_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS INDICI VOLATILITY M15 A 1 MINUTO (controllo del rapporto tick/1 minuto): 15 set volatility breakout di Wim (US30: U3V12, U3V08, VOL_M15_a, b, c, g; US500: U5W10, VolUS500_a, c, g; USTEC: NAS_VOL_M15_A, B, C, D, E) dal Library pack, su simboli BCM nativi U30USD, SPXUSD, NASUSD, EA Ultimate_Breakout_EA_WSC_V9.5.ex5, DEMO, SOLO TESTER, SOLO Modello 1 (barre da 1 minuto OHLC, per il rapporto tick/1 minuto), M15, finestra 01/01/2025 - 13/11/2026, deposito 100000 EUR, input imposti Risk=0, StartLots=0.1 e ForceSymbol = simbolo BCM = 15 passate. Serve a misurare se i numeri di Wim sui suoi set volatility M15 si ripetono con i nostri dati. Criteri: report/UBS_INDICI_VOL_M15_CRITERI_2026-11-21.md. PRIMA di questa riga va lanciata ESTRAI_SET_VOL_M15 (crea UBS_LIBPACK_VOL_M15.zip sul Desktop). Mi mandi lo zip ANNO_ORO_GRADINI_UBSVM15M1_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 1 minuto OHLC su 22 mesi per 15 set M15: pochi minuti ciascuno, stima meno di 1 ora in tutto (prima passata con eventuale download dei tick dal server BCM); (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_VM15M1.txt'
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
print('patch ok', len(_t), 'passate 15')

_t2 = open('righe/RIGA_LANCIA_UBS_VM15M1.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_VM15M1.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_VM15M1.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_VM15M1.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)
