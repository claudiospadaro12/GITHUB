#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [  # 17 set: i 7 del cancello M1 + CLI_HJP09/10 + 6 volatility breakout + OTH_GU_a + OTH_EU_b (HANG1/HANG4 e OTH_EU_a esclusi: lotto da rischio / P2 in perdita)
 ('Indicement\\USTEC(H1)\\US100_1.set','H1','NASUSD_EXT','IDX_NAS_US100_1'),
 ('Indicement\\US500\\US500a.set','H1','SPXUSD_EXT','IDX_SPX_US500a'),
]
assert len(FX) == 2
nuovo = ("ZNEW = 'Ultimate-Breakout-System-Set-Files.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []; MODS = []\n"
         "for rel, per, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, ZNEW, '2019', '2019.07.01', per, rel, IMPFX + ';ForceSymbol=' + sym + ':s', 'UBSIDX0_%s_M%s_100000_2019H1' % (tag, mod), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 2")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_IDX0.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSIDX0_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS INDICI, PASSATA DI FUMO (2 passate, solo tester): set Indicement di Wim USTEC H1 (US100_1) su NASUSD_EXT e US500a su SPXUSD_EXT, 01/01/2019 - 30/06/2019, Modello 1 (1 minuto OHLC), deposito 100000 EUR, lotto fisso 0,1 (Risk=0, StartLots=0,1), ForceSymbol imposto al simbolo del grafico. Serve SOLO a vedere se l EA apre operazioni sui simboli _EXT e con quale ordine di grandezza; i risultati NON si usano per giudicare la strategia. EA Ultimate_Breakout_EA_WSC_V9.5.ex5, DEMO. Criteri: report/UBS_INDICI_OTTIMIZZAZIONE_CRITERI_2026-11-21.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSIDX0_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: pochi minuti per passata (6 mesi, Modello 1, H1); (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_IDX0.txt'
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
_t = _t.replace('DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip)', 'zip dei set (Ultimate-Breakout-System-Set-Files.zip)')
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 100000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 2')

_t2 = open('righe/RIGA_LANCIA_UBS_IDX0.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_IDX0.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_IDX0.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_IDX0.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)
