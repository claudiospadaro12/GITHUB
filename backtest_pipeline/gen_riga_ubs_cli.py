#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
FX = [ ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\USTEC(H1)\\US100_1.set', 'NASUSD_EXT_T', 'CLI_US100_1'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\USTEC(H1)\\US100_2.set', 'NASUSD_EXT_T', 'CLI_US100_2'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\USTEC(H1)\\US100_3.set', 'NASUSD_EXT_T', 'CLI_US100_3'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\USTEC(H1)\\US100_4.set', 'NASUSD_EXT_T', 'CLI_US100_4'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\US500\\US500a.set', 'SPXUSD_EXT_T', 'CLI_US500a'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'M15', 'Indicement\\US500\\US500b.set', 'SPXUSD_EXT_T', 'CLI_US500b'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'M15', 'Indicement\\US500\\US500c.set', 'SPXUSD_EXT_T', 'CLI_US500c'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'H1', 'Indicement\\US500\\US500d.set', 'SPXUSD_EXT_T', 'CLI_US500d'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'D1', 'Indicement\\US500\\US500e.set', 'SPXUSD_EXT_T', 'CLI_US500e'),
 ('Ultimate-Breakout-System-Set-Files.zip', '2010', '2020.01.01', 'D1', 'Indicement\\US500\\US500f.set', 'SPXUSD_EXT_T', 'CLI_US500f'),
]
assert len(FX) == 10
nuovo = ("ZNEW = 'UBS_LIBPACK_VOL_M15.zip'\n"
         "FX = " + repr(FX) + "\n"
         "IMPFX = 'Risk=0:i;StartLots=0.1:d'\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, IMPFX + ';ForceSymbol=' + sym + ':s', 'UBSCLI_%s_M%s_100000_%s' % (tag, mod, anno), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 10")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_CLI.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSCLI_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS INDICE INDICEMENT, CONTROLLO C0 SUI CLONI _EXT_T (Modello 1, lotto fisso 0,1, deposito 100000 EUR): 10 set di Wim (US100_1-4 su NASUSD_EXT_T, US500a-f su SPXUSD_EXT_T) su 2010-01-01 - 2019-12-31, senza ottimizzare. Serve a vedere se, con gli ordini accettati, i set pubblicati funzionano fuori dal loro campione 2020-2023. PRIMA va lanciata la riga CLONA_INDICI (storico _EXT dal 2010). Criteri: report/UBS_INDICI_OTTIMIZZAZIONE_CRITERI_2026-11-21.md (previsione I-8). Mi mandi lo zip ANNO_ORO_GRADINI_UBSCLI_<data>. MT5 CHIUSO. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 10 passate di 10 anni a 1 minuto: stima 1-2 ore, non misurata; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_CLI.txt'
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
print('patch ok', len(_t), 'passate 10')

_t2 = open('righe/RIGA_LANCIA_UBS_CLI.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_CLI.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_CLI.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_CLI.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_CLI.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_CLI.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_CLI.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=40;").replace("timeout 300 minuti", "timeout 40 minuti")
open('righe/RIGA_LANCIA_UBS_CLI.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')
