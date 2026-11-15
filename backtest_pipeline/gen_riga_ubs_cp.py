#!/usr/bin/env python3
"""[U5] derivata da gen_riga_ubs_u2.py. UBS U5: la candela di conferma dei set V9.0 cambia il risultato? 12 passate: 2 controlli (set vecchi dal pacchetto da 283: dailyC su P1, GOLDTRADEPRO_E su P2), 8 passate V9.0 (dailyC, dailyI, GOLDTRADEPRO_E, GOLDTRADEPRO_a x P1/P2) e 2 passate della variante "UBS live portfolio" di GOLDTRADEPRO_E (candela ON + NFP ON) x P1/P2. Set cosi come consegnati (lotto fisso 0,1), XAUUSD, Modello 1, deposito 100000 EUR. Criteri: report/UBS_U5_CRITERI_2026-11-14.md.
Uso: python3 gen_riga_ubs_u5.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
nuovo = ("ZNEW = 'UPDATED_SETS_UBS_V9_0.zip'\n"
         "PILOT = [('Breakout_Support_Resistance\\\\ORB Master\\\\USTEC_M15_a.set', 'M15', 'NASUSD', 'ORB_USTEC_a'), ('Breakout_Support_Resistance\\\\ORB Master\\\\DAX_M15_a.set', 'M15', 'D30EUR', 'ORB_DAX_a'), ('Breakout_Support_Resistance\\\\ORB Master\\\\US30_M15_c.set', 'M15', 'U30USD', 'ORB_US30_c'), ('Breakout_Support_Resistance\\\\ORB Master\\\\US500_M15_d.set', 'M15', 'SPXUSD', 'ORB_US500_d'), ('Volatility Breakout\\\\EURUSD\\\\new EURUSD VolBreakout\\\\EURUSD_M15_VolBrk_C10.set', 'M15', 'EURUSD', 'VOL_EURUSD_C10'), ('Breakout_Support_Resistance\\\\Advanced Scalper\\\\usdjpy_H4_SL14.set', 'H4', 'USDJPY', 'SCALP_USDJPY_H4'), ('Client sets\\\\Till\\\\9637034_Till_UBS-USDJPY-D1-HJP09.set', 'D1', 'USDJPY', 'CLI_USDJPY_HJP09'), ('Breakout_Support_Resistance\\\\Other sets\\\\daytrade 2(DAILY)\\\\eurusd_a.set', 'D1', 'EURUSD', 'OTH_EURUSD_a')]\n"
         "SYMS = [x[2] for x in PILOT]\n"
         "for rel, per, sym, tag in PILOT:\n"
         "    runs.append((EA, ZNEW, '2025', '2026.01.01', per, rel, '', 'UBSCP_%s_100000_2025' % tag, 100000))\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 8")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_CP.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSCP_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS C PILOTA: 8 set di Wim (4 ORB Master: Nasdaq, DAX, Dow, S&P; 1 volatility breakout EURUSD; 1 scalper USDJPY H4; 1 USDJPY D1; 1 EURUSD D1) dal pacchetto UPDATED_SETS_UBS_V9_0.zip, set COSI COME CONSEGNATI (nessun input imposto), sul simbolo BCM (NASUSD, D30EUR, U30USD, SPXUSD, EURUSD, USDJPY), EA Ultimate_Breakout_EA_WSC_V9.5.ex5, DEMO, SOLO TESTER, Modello 1, anno 2025, deposito 100000 EUR: 8 passate. Serve a verificare nomi dei simboli, fuso orario degli ORB e orari di sessione PRIMA dei 40 set. Criteri: report/UBS_C_ELENCO_40_SET_2026-11-15.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSCP_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: circa 1,5-2 ore (\" + str(N) + \" passate: 9 set su 6-7 anni, 2 periodi;")
sys.argv = ['gen_riga_ubs_cp_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_CP.txt'
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
