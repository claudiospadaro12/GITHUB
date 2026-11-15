#!/usr/bin/env python3
"""UBS C FOREX (derivata da gen_riga_ubs_cp.py): 20 set forex V9.0 x 2 periodi (P1 2013-2018, P2 2019-2025), lotto fisso 0,1 uguale per tutti, 40 passate.
Uso: python3 gen_riga_ubs_cf.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [  # (percorso nel pacchetto V9.0, timeframe, simbolo, tag)
 ('Volatility Breakout\\EURUSD\\new EURUSD VolBreakout\\EURUSD_M15_VolBrk_C10.set','M15','EURUSD','VOL_C10'),
 ('Volatility Breakout\\EURUSD\\new EURUSD VolBreakout\\EURUSD_M15_VolBrk_C20.set','M15','EURUSD','VOL_C20'),
 ('Volatility Breakout\\EURUSD\\new EURUSD VolBreakout\\EURUSD_M15_VolBrk_C37.set','M15','EURUSD','VOL_C37'),
 ('Volatility Breakout\\EURUSD\\new EURUSD VolBreakout\\EURUSD_M15_VolBrk_C63.set','M15','EURUSD','VOL_C63'),
 ('Volatility Breakout\\EURUSD\\EURUSD_e.set','M15','EURUSD','VOL_e'),
 ('Volatility Breakout\\EURUSD\\EURUSD_f.set','M15','EURUSD','VOL_f'),
 ('Volatility Breakout\\EURUSD\\EURUSD_k.set','M15','EURUSD','VOL_k'),
 ('Volatility Breakout\\EURUSD\\EURUSD_o.set','M15','EURUSD','VOL_o'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\eurusd_H1_SL17.set','H1','EURUSD','SCALP_EU_SL17'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\eurusd_H1_SL22.set','H1','EURUSD','SCALP_EU_SL22'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\usdjpy_H1_SL22.set','H1','USDJPY','SCALP_UJ_H1'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\usdjpy_H4_SL14.set','H4','USDJPY','SCALP_UJ_H4'),
 ('Breakout_Support_Resistance\\Advanced Scalper\\gbpusd_H1.set','H1','GBPUSD','SCALP_GU_H1'),
 ('Breakout_Support_Resistance\\Other sets\\daytrade 2(DAILY)\\eurusd_a.set','D1','EURUSD','OTH_EU_a'),
 ('Breakout_Support_Resistance\\Other sets\\daytrade 2(DAILY)\\eurusd_b.set','D1','EURUSD','OTH_EU_b'),
 ('Breakout_Support_Resistance\\Other sets\\daytrade 2(DAILY)\\gbpusd_a.set','D1','GBPUSD','OTH_GU_a'),
 ('Client sets\\Till\\9637034_Till_UBS-USDJPY-D1-HJP09.set','D1','USDJPY','CLI_HJP09'),
 ('Client sets\\Till\\9637035_Till_UBS-USDJPY-D1-HJP10.set','D1','USDJPY','CLI_HJP10'),
 ('Client sets\\hangsan\\9637057_hangsan_1.set','D1','USDJPY','CLI_HANG1'),
 ('Client sets\\hangsan\\9637058_hangsan_4.set','D1','USDJPY','CLI_HANG4'),
]
assert len(FX) == 20 and len(set(x[3] for x in FX)) == 20
nuovo = ("ZNEW = 'UPDATED_SETS_UBS_V9_0.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []\n"
         "for rel, per, sym, tag in FX:\n"
         "    runs.append((EA, ZNEW, '2013', '2019.01.01', per, rel, IMPFX, 'UBSCF_%s_100000_2013-2018' % tag, 100000)); SYMS.append(sym)\n"
         "    runs.append((EA, ZNEW, '2019', '2026.01.01', per, rel, IMPFX, 'UBSCF_%s_100000_2019-2025' % tag, 100000)); SYMS.append(sym)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 40")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_CF.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSCF_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS C FOREX: 20 set di Wim (4 volatility breakout EURUSD M15 C10 C20 C37 C63; 4 volatility breakout EURUSD e f k o (TF del grafico M15: ASSUNTO, il set ha periodo 0 = quello del grafico); 5 Advanced Scalper EURUSD H1 x2, USDJPY H1, USDJPY H4, GBPUSD H1; 3 daily EURUSD a, EURUSD b, GBPUSD a; 4 client USDJPY D1) dal pacchetto UPDATED_SETS_UBS_V9_0.zip, EA Ultimate_Breakout_EA_WSC_V9.5.ex5, DEMO, SOLO TESTER, Modello 1, deposito 100000 EUR, DUE periodi per set: P1 2013-01-01 -> 2019-01-01 e P2 2019-01-01 -> 2026-01-01 = 40 passate. Input imposti IGUALI PER TUTTI per confrontare i netti: Risk=0 e StartLots=0.1 (lotto fisso 0,1); tutti gli altri input restano quelli del set e si controllano nel report. Criteri: report/UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md (Fase 2) e report/RISULTATI_UBS_C_PILOTA_2026-11-15.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSCF_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: circa 1-2 ore (\" + str(N) + \" passate: 20 set x 2 periodi di 6-7 anni; il pilota ha misurato 28 secondi per un anno M15, quindi 6-7 anni ~3-4 minuti per passata M15, meno per D1; STIMA non misurata su piu anni, e la prima volta che il tester scarica gli anni vecchi del forex puo essere piu lenta;")
sys.argv = ['gen_riga_ubs_cp_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_CF.txt'
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
