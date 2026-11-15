#!/usr/bin/env python3
"""[U5] derivata da gen_riga_ubs_u2.py. UBS U5: la candela di conferma dei set V9.0 cambia il risultato? 12 passate: 2 controlli (set vecchi dal pacchetto da 283: dailyC su P1, GOLDTRADEPRO_E su P2), 8 passate V9.0 (dailyC, dailyI, GOLDTRADEPRO_E, GOLDTRADEPRO_a x P1/P2) e 2 passate della variante "UBS live portfolio" di GOLDTRADEPRO_E (candela ON + NFP ON) x P1/P2. Set cosi come consegnati (lotto fisso 0,1), XAUUSD, Modello 1, deposito 100000 EUR. Criteri: report/UBS_U5_CRITERI_2026-11-14.md.
Uso: python3 gen_riga_ubs_u5.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
nuovo = ("ZOLD = 'Ultimate-Breakout-System-Set-Files.zip'\n"
         "P1 = ('2013', '2019.01.01', '2013-2018'); P2 = ('2019', '2026.01.01', '2019-2025')\n"
         "REV = 'ReverseTrades=true:b'\n"
         "RSETS = [('GOLD\\\\Gold_Phantom_strat8.set', 'H1', 'PH_strat8'), ('GOLD\\\\Gold_Phantom_strat3.set', 'D1', 'PH_strat3'), ('GOLD\\\\Goldbot One\\\\dailyC.set', 'D1', 'GB_dailyC'), ('GOLD\\\\Goldtrade Pro\\\\GOLDTRADEPRO_E.set', 'D1', 'GTP_E'), ('GOLD\\\\Gold Phantom(daily)\\\\Gold_c.set', 'D1', 'PHd_c'), ('GOLD\\\\Goldbot One\\\\dailyI.set', 'D1', 'GB_dailyI'), ('GOLD\\\\Goldtrade Pro\\\\GOLDTRADEPRO_a.set', 'D1', 'GTP_a'), ('GOLD\\\\Gold Reaper\\\\strategy5_H1.set', 'H1', 'GR_s5_H1'), ('GOLD\\\\Gold Reaper\\\\strategy1_Daily.set', 'D1', 'GR_s1_D1')]\n"
         "for rel, per, tag in RSETS:\n"
         "    for P in (P1, P2):\n"
         "        runs.append((EA, ZOLD, P[0], P[1], per, rel, REV, 'UBSR_%s_100000_%s' % (tag, P[2]), 100000))\n")
s = s[:a] + nuovo + s[b:]
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 18")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_R.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSR_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS R: PROVA DI ReverseTrades SUI SET ORO. 9 set oro di Wim (Phantom strat8, strat3 e Gold_c, Goldbot dailyC e dailyI, Gold Trade Pro E e a, Reaper s5 H1 e s1 D1) dal pacchetto Ultimate-Breakout-System-Set-Files.zip con SOLO ReverseTrades=true imposto (inverte buy e sell), EA Ultimate_Breakout_EA_WSC_V9.5.ex5, XAUUSD, DEMO, SOLO TESTER, Modello 1, deposito 100000 EUR, lotto fisso 0,1, periodi 2013-2018 e 2019-2025: 18 passate. Se un set non ha ReverseTrades la passata va KO e si scrive. Criteri e previsioni: report/UBS_ORO_NON_CORRELATI_REVERSE_CRITERI_2026-11-15.md. Mi mandi lo zip ANNO_ORO_GRADINI_UBSR_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: circa 1,5-2 ore (\" + str(N) + \" passate: 9 set su 6-7 anni, 2 periodi;")
sys.argv = ['gen_riga_ubs_r_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_r_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_R.txt'
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
print('patch ok', len(_t), 'passate 18')
