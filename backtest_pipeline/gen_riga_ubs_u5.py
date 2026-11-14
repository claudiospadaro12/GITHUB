#!/usr/bin/env python3
"""[U5] derivata da gen_riga_ubs_u2.py. UBS U5: la candela di conferma dei set V9.0 cambia il risultato? 12 passate: 2 controlli (set vecchi dal pacchetto da 283: dailyC su P1, GOLDTRADEPRO_E su P2), 8 passate V9.0 (dailyC, dailyI, GOLDTRADEPRO_E, GOLDTRADEPRO_a x P1/P2) e 2 passate della variante "UBS live portfolio" di GOLDTRADEPRO_E (candela ON + NFP ON) x P1/P2. Set cosi come consegnati (lotto fisso 0,1), XAUUSD, Modello 1, deposito 100000 EUR. Criteri: report/UBS_U5_CRITERI_2026-11-14.md.
Uso: python3 gen_riga_ubs_u5.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
nuovo = ("ZOLD = 'Ultimate-Breakout-System-Set-Files.zip'; ZNEW = 'UPDATED_SETS_UBS_V9_0.zip'\n"
         "P1 = ('2013', '2019.01.01', '2013-2018'); P2 = ('2019', '2026.01.01', '2019-2025')\n"
         "def add(zip_, rel, per, tag, P):\n"
         "    runs.append((EA, zip_, P[0], P[1], per, rel, '', 'UBSU5_%s_100000_%s' % (tag, P[2]), 100000))\n"
         "# controlli: versione VECCHIA (candela OFF), percorso dentro lo zip da 283\n"
         "add(ZOLD, 'GOLD\\\\Goldbot One\\\\dailyC.set', 'D1', 'CTRL_GB_dailyC', P1)\n"
         "add(ZOLD, 'GOLD\\\\Goldtrade Pro\\\\GOLDTRADEPRO_E.set', 'D1', 'CTRL_GTP_E', P2)\n"
         "# braccio V1: set V9.0 (candela ON)\n"
         "for rel, tag in [('Breakout_Support_Resistance\\\\GOLD\\\\Goldbot One\\\\dailyC.set', 'V9_GB_dailyC'), ('Breakout_Support_Resistance\\\\GOLD\\\\Goldbot One\\\\dailyI.set', 'V9_GB_dailyI'), ('Breakout_Support_Resistance\\\\GOLD\\\\Goldtrade Pro\\\\GOLDTRADEPRO_E.set', 'V9_GTP_E'), ('Breakout_Support_Resistance\\\\GOLD\\\\Goldtrade Pro\\\\GOLDTRADEPRO_a.set', 'V9_GTP_a')]:\n"
         "    add(ZNEW, rel, 'D1', tag, P1); add(ZNEW, rel, 'D1', tag, P2)\n"
         "# braccio V2: variante live portfolio di GOLDTRADEPRO_E (candela ON + NFP ON)\n"
         "add(ZNEW, 'UBS live portfolio\\\\Sets\\\\GOLDTRADEPRO_E.set', 'D1', 'LIVE_GTP_E', P1); add(ZNEW, 'UBS live portfolio\\\\Sets\\\\GOLDTRADEPRO_E.set', 'D1', 'LIVE_GTP_E', P2)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 12")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_U5.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSU5_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("U5 UBS: LA CANDELA DI CONFERMA DEI SET V9.0. 4 set oro di Wim (Goldbot One dailyC e dailyI, Gold Trade Pro E e a) nella versione V9.0 (UseConfirmationCandle ON) dal pacchetto UPDATED_SETS_UBS_V9_0.zip, piu la variante UBS live portfolio del Gold Trade Pro E (candela ON + filtro NFP ON) e DUE controlli con i set vecchi dal pacchetto Ultimate-Breakout-System-Set-Files.zip (candela OFF) per verificare la riproducibilita. EA Ultimate_Breakout_EA_WSC_V9.5.ex5 (cartella WIM di MQL5\\\\\\\\Experts), XAUUSD, DEMO, SOLO TESTER, Modello 1, deposito 100000 EUR, due periodi: 2013-01-01 -> 2019-01-01 e 2019-01-01 -> 2026-01-01; set COSI COME CONSEGNATI (lotto fisso 0,1, nessun input imposto). 12 passate. Criteri e previsioni: report/UBS_U5_CRITERI_2026-11-14.md. Mi mandi la cartella ABTG_RISULTATI\\\\\\\\ANNO_ORO_GRADINI_UBSU5_<data>. Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")\n')
s = s[:i] + testa + s[j:]
s = s.replace("il file Ultimate-Breakout-System-Set-Files.zip (il pacchetto dei set di Wim) deve stare sul Desktop", "i DUE file Ultimate-Breakout-System-Set-Files.zip (283 set) e UPDATED_SETS_UBS_V9_0.zip (382 set), i pacchetti dei set di Wim, devono stare sul Desktop")
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: circa 1-2 ore (\" + str(N) + \" passate: 4 set + variante live + 2 controlli, su 6-7 anni ciascuno;")
sys.argv = ['gen_riga_ubs_u5_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_u5_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_U5.txt'
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
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 100000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 12')
