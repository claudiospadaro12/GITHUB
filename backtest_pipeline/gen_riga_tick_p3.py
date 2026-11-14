#!/usr/bin/env python3
"""[TICKP3] derivata da gen_riga_d160_oro.py. Componenti ORO di P3 a TICK REALI (Modello 4), solo 2025, deposito 80000: Goldbot One Combo 3GOLD (Goldbot_PropFirm_combo_3GOLD.set da combodeal.zip) + Gold Trade Pro Combo (input Risk=3, MaxRiskPerStrategy 0.5, PropFirmMaxDailyDD 4.0, come nel test GTP_COMBO_TRE_ANNI_80K) = 2 passate.
Criteri: report/CRITERI_P3_P4_VS_P1_P4_2026-11-14.md (misura M1). Uso: python3 gen_riga_tick_p3.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_d160_oro.py', encoding='utf-8').read()
def rep(a, b, n=1):
    global s
    assert s.count(a) == n, (s.count(a), a[:80])
    s = s.replace(a, b)
IMPS = 'Risk=3:i;MaxRiskPerStrategy=0.5:d;PropFirmMaxDailyDD=4.0:d'
rep("N = len(runs)\nassert N == 24",
    "runs = [('Goldbot One MT5.ex5', ZIP, '2025', '', 'D1', 'Goldbot_PropFirm_combo_3GOLD.set', '', 'TICKP3_GB_L3_80000_2025', 80000),\n"
    "        ('Gold Trade Pro MT5.ex5', ZIP, '2025', '', 'D1', '', '" + IMPS + "', 'TICKP3_GTP_COMBO_80000_2025', 80000)]\n"
    "N = len(runs)\nassert N == 2")
rep("q(['1'] * N)", "q(['4'] * N)")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("TICKP3 ORO: LA PARTE ORO DI P3 A TICK REALI. Goldbot One Combo 3GOLD (Goldbot_PropFirm_combo_3GOLD.set, set UFFICIALE da combodeal.zip, nessun input cambiato) e Gold Trade Pro COMBO (XAUUSD D1, input Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0, gli stessi del test GTP_COMBO_TRE_ANNI_80K): UNA passata ciascuno sul 2025 (01/01/2025 - 01/01/2026), XAUUSD D1, DEMO, SOLO TESTER, Modello 4 (tick reali), deposito 80000 EUR. Serve a misurare quanto cambiano i risultati di P3 rispetto alle passate a candele da 1 minuto gia fatte (rapporti netto, DD, PF). 2 passate. Criteri e previsioni: report/CRITERI_P3_P4_VS_P1_P4_2026-11-14.md. Nessun giudizio su taglie o acquisti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")\n')
s = s[:i] + testa + s[j:]
rep("MOLTE ORE (\" + str(N) + \" passate, stima 4-5 ore, non misurata); timeout 90 minuti per passata (NON 600).", "ORE (\" + str(N) + \" passate a tick reali su un anno, D1: stima 1-3 ore in tutto, non misurata); timeout 300 minuti per passata.")
rep('"$TO=90;"', '"$TO=300;"')
rep("ANNO_ORO_GRADINI_D160ORO_", "ANNO_ORO_GRADINI_TICKP3_")
rep("RIGA_LANCIA_D160_ORO.txt", "RIGA_LANCIA_TICK_P3.txt")
sys.argv = ['gen_riga_tick_p3_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_tick_p3_tmp', 'exec'))
_p = 'righe/RIGA_LANCIA_TICK_P3.txt'
_t = open(_p, encoding='ascii').read()
def P(a, b, n=1):
    global _t
    assert _t.count(a) == n, (_t.count(a), a[:90])
    _t = _t.replace(a, b)
# GTP si lancia con input (nessun set): il set e opzionale solo quando SETR e vuoto
P("foreach($sn in @($SETR | Select-Object -Unique)){", "foreach($sn in @($SETR | Select-Object -Unique | Where-Object { $_ -ne '' })){")
P("if($sf -eq ''){ Write-Host ('SET NON TROVATO", "if($sf -eq '' -and $SETR[$vi] -ne ''){ Write-Host ('SET NON TROVATO")
P("-SetFile $sf ", "@sfa ", 2)
P("$an=$ANNI[$vi];", "$sfa=@(); if($sf -ne ''){ $sfa=@('-SetFile',$sf) }; $an=$ANNI[$vi];")
_a = "if($okl.Count -lt 3){ throw 'Mancano uno o piu EA oro (The Gold Reaper MT5.ex5, The Gold Phantom.ex5, Goldbot One MT5.ex5) in MQL5\\Experts di questo terminale. Nessun tester e partito.' }"
_b = "if($okl.Count -lt 2){ throw 'Mancano Goldbot One MT5.ex5 o Gold Trade Pro MT5.ex5 in MQL5\\Experts di questo terminale (anche in una sottocartella, per esempio Market). Nessun tester e partito.' }"
P(_a, _b)
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 80000 EUR').replace('deposito 80000 o 3745 EUR', 'deposito 80000 EUR').replace('3745', '80000')
P('DA PROVARE A 80K: ', 'DA PROVARE: ')
P('The Gold Reaper, The Gold Phantom e Goldbot One devono essere gia installati (Market) su QUESTO terminale, UNA copia sola ciascuno', 'Goldbot One e Gold Trade Pro devono essere gia installati (Market o demo del Market) su QUESTO terminale, UNA copia sola ciascuno')
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), '3745 assente:', '3745' not in _t)
