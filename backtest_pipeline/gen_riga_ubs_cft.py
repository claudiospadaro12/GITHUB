#!/usr/bin/env python3
"""UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [  # (percorso nel pacchetto V9.0, timeframe, simbolo, tag): i 7 set a lotto 0,1 che hanno passato la Fase 2 M1
 ('Breakout_Support_Resistance\\Advanced Scalper\\eurusd_H1_SL17.set','H1','EURUSD','SCALP_EU_SL17'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\eurusd_H1_SL22.set','H1','EURUSD','SCALP_EU_SL22'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\gbpusd_H1.set','H1','GBPUSD','SCALP_GU_H1'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\usdjpy_H1_SL22.set','H1','USDJPY','SCALP_UJ_H1'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\usdjpy_H4_SL14.set','H4','USDJPY','SCALP_UJ_H4'),
 ('Volatility Breakout\\EURUSD\\EURUSD_f.set','M15','EURUSD','VOL_f'),
 ('Volatility Breakout\\EURUSD\\EURUSD_o.set','M15','EURUSD','VOL_o'),
]
assert len(FX) == 7
nuovo = ("ZNEW = 'UPDATED_SETS_UBS_V9_0.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []; MODS = []\n"
         "for rel, per, sym, tag in FX:\n"
         "    for mod in ('1', '4'):\n"
         "        runs.append((EA, ZNEW, '2025', '2026.01.01', per, rel, IMPFX, 'UBSCFT_%s_M%s_100000_2025' % (tag, mod), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 14")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_CFT.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSCFT_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS C FOREX A TICK REALI: 7 set di Wim che hanno passato la Fase 2 a candele da 1 minuto (scalper EURUSD H1 SL17 e SL22, GBPUSD H1, USDJPY H1 SL22 e H4 SL14; volatility breakout EURUSD f e o) dal pacchetto UPDATED_SETS_UBS_V9_0.zip, EA Ultimate_Breakout_EA_WSC_V9.5.ex5, DEMO, SOLO TESTER, anno 2025 (01/01/2025 - 01/01/2026), deposito 100000 EUR, input imposti Risk=0 e StartLots=0.1 (lotto fisso 0,1). Per ogni set DUE passate sulla STESSA finestra: Modello 1 (candele da 1 minuto) e Modello 4 (TICK REALI) = 14 passate. Serve a misurare quanto il Modello 1 favorisce gli scalper: rapporto PF, DD, operazioni e % vincenti fra tick reali e M1 (soglie del piano: PF tick/M1 >= 0,7, DD tick <= 1,5 x M1). Criteri: report/RISULTATI_UBS_C_FOREX_2026-11-15.md e report/UBS_COMBINAZIONI_PIANO_2026-11-15.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSCFT_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: i 7 set M1 sono pochi minuti ciascuno; le 7 passate a TICK REALI di un anno forex sono NON MISURATE per il forex (le passate a tick sull oro D1 hanno impiegato poco, ma gli scalper H1 fanno molte piu operazioni e il forex ha molti piu tick): stima 1-4 ore in tutto, prima passata a tick con download dei tick dal server BCM (puo essere lenta e puo mostrare qualita di storico sotto 100% se i tick non coprono il 2025: la qualita e nel manifest); (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_CFT.txt'
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
_t = _t.replace('DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip)', 'zip dei set (UPDATED_SETS_UBS_V9_0.zip)')
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 100000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 8')

_t2 = open('righe/RIGA_LANCIA_UBS_CFT.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_CFT.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))
