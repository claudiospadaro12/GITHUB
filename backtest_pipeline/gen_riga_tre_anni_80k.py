#!/usr/bin/env python3
"""Genera righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt dalla riga dei tre anni a 5K (stessa struttura, gia passata dal cancello).
SHA256 dello script calcolato da `git show PIN:backtest_pipeline/righe/ANNO80K_TESTER.ps1`. Uso: python3 gen_riga_tre_anni_80k.py <PIN40>"""
import sys, re, hashlib, subprocess, os
GB = len(sys.argv) > 2 and sys.argv[2] == 'goldbot'; PIN = sys.argv[1]; assert re.fullmatch(r'[0-9a-f]{40}', PIN) and set(PIN) != {'0'}
os.chdir(os.path.dirname(os.path.abspath(__file__)))
sh = hashlib.sha256(subprocess.check_output(['git', 'show', PIN + ':backtest_pipeline/righe/ANNO80K_TESTER.ps1'])).hexdigest().upper(); assert re.fullmatch(r'[0-9A-F]{64}', sh)
t = open('righe/RIGA_LANCIA_TRE_ANNI_5K.txt', encoding='ascii').read()
old_pin = re.search(r"\$PIN='([0-9a-f]{40})'", t).group(1); t = t.replace(old_pin, PIN)
def sost(a, b, cnt=1):
    global t
    assert t.count(a) >= 1, a[:60]
    t = t.replace(a, b) if cnt == 0 else t.replace(a, b, cnt)
# 1. messaggio di testa
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("TRE ANNI DELLO STORICO DELL ORO PER 3 EA A 80.000 EUR (DEMO, SOLO TESTER): The Gold Reaper (il tuo set), Goldbot One (step 6000, D1) e Prop Firm Gold EA, per vedere se reggono ANNI DI REGIME DIVERSO non consecutivi: 2013 SHORT (-28%), 2018 LATERALE (-1,7%), 2020 LONG (+24,6%), scelti con una regola scritta prima dai soli prezzi D1 BCM. Per ogni EA e anno UNA passata a conto vuoto da 80000 EUR, XAUUSD, Modello 1 (OHLC 1 minuto: NON tick reali, che l oro ha solo dal 10/07/2024), leva 1:100, nessun guardiano esterno. Piu il 2025 come CALIBRAZIONE (Modello 1 contro il Modello 4 gia in repo; per Goldbot One anche 2025 a tick reali, circa 1-2 ore). 13 passate: ordine 2025 (M1 e per Goldbot M4), 2013, 2018, 2020, e dentro ogni anno Gold Reaper, Goldbot One, Prop Firm Gold. Tempo: da pochi minuti a circa 2 ore ciascuna, in tutto alcune ore; per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito): ogni passata finita ha gia la sua cartella e il suo zip in ABTG_RISULTATI. Mi mandi la cartella ABTG_RISULTATI\\ANNO80K_TRE_EA_<data> (o lo zip finale). Criteri, calibrazione e previsioni scritti PRIMA dei numeri: report/TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md; lettore congelato backtest_pipeline/leggi_tre_anni_80k.py. Gold Reaper ha le sue due protezioni interne ACCESE (MaxAllowedDD=9, PropFirmMaxDailyDD=4). Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
if GB:
    testa = ("GOLDBOT ONE (step 6000, D1) A 80.000 EUR SU 2013 SHORT, 2018 LATERALE, 2020 LONG + CALIBRAZIONE 2025 (DEMO, SOLO TESTER): RIPETIZIONE della sola parte di Goldbot One del giro dei tre anni, perche le sue passate si erano fermate sul controllo del periodo (D1 non era ammesso dallo script: errore MIO, corretto nello script v2). Gold Reaper e Prop Firm Gold sono gia misurati. Per ogni anno UNA passata a conto vuoto da 80000 EUR, XAUUSD D1, Modello 1 (OHLC 1 minuto: NON tick reali, che l oro ha solo dal 10/07/2024), leva 1:100, nessun guardiano esterno; input imposti come la prova a tick reali: Risk=9999, MaxRiskPerStrategy=6.0, StartLots=0.01, LotPerBalance_step=6000. 5 passate: 2025 Modello 1, 2025 Modello 4 (tick reali, calibrazione, circa 1-2 ore), 2013, 2018, 2020. Tempo: in tutto circa 2-4 ore; per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Mi mandi la cartella ABTG_RISULTATI\\ANNO80K_GOLDBOT_<data> (o lo zip finale). Criteri, calibrazione e previsioni scritti PRIMA dei numeri: report/TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md; lettore congelato backtest_pipeline/leggi_tre_anni_80k.py. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
# 2. liste
fare = ["Goldbot One MT5.ex5"] if GB else ["The Gold Reaper MT5.ex5", "Goldbot One MT5.ex5", "Prop Firm Gold EA.ex5"]
runs = [(e, '2025', '1', 'D1' if 'Goldbot' in e else 'H1') for e in fare] + [("Goldbot One MT5.ex5", '2025', '4', 'D1')] + [(e, y, '1', 'D1' if 'Goldbot' in e else 'H1') for y in ('2013', '2018', '2020') for e in fare]
q = lambda L: ','.join("'" + x + "'" for x in L)
a = t.index('$fare=@('); b = t.index('$IMP=@{')
nuovo = "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $vi=0; "
t = t[:a] + nuovo + t[b:]
a = t.index('$IMP=@{'); b = t.index('}; $tutti=', a)
imp = "$IMP=@{ 'The Gold Reaper MT5.ex5' = 'TradeFrequency=2:i;MaxAllowedDD=9.0:d;PropFirmMaxDailyDD=4.0:d;OnlyUp=false:b'; 'Goldbot One MT5.ex5' = 'Risk=9999:i;MaxRiskPerStrategy=6.0:d;StartLots=0.01:d;LotPerBalance_step=6000:i'"
t = t[:a] + imp + " " + t[b:]
# 3. $fare unico (nomi distinti) per il controllo di presenza nel Market: $fare e usato anche come elenco di corse; si controlla su un elenco distinto
sost("foreach($n in $fare){ if($nomi -contains $n){ $okl += $n;", "foreach($n in @($fare | Select-Object -Unique)){ if($nomi -contains $n){ $okl += $n;")
sost("$fare=@($okl); if($fare.Count -eq 0){ throw 'Nessuno dei 9 EA e nel Market di questo terminale. Nessun tester e partito.' }", "if($okl.Count -lt " + str(len(fare)) + "){ throw 'Mancano EA nel Market di questo terminale (servono: " + ', '.join(fare) + "). Nessun tester e partito.' }")
sost("DA PROVARE A 5K: ", "DA PROVARE A 80K: ")
sost("EA da provare a 5000 EUR: ' + $fare.Count + ' (una sola corsa continua ciascuno)'", "passate da fare a 80000 EUR: ' + $fare.Count + ' (conto vuoto ciascuna)'")
# 4. script
sost("$SN='ANNO5K_TESTER.ps1'", "$SN='ANNO80K_TESTER.ps1'"); sost("$MA='MARCATORE_ANNO5K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'")
old_sh = re.search(r"\$SH='([0-9A-F]{64})'", t).group(1); t = t.replace(old_sh, sh)
# 5. cartelle e zip
NOMEF = 'ANNO80K_GOLDBOT_' if GB else 'ANNO80K_TRE_EA_'
sost("ABTG_RISULTATI\\ANNO5K_TRE_ANNI_'", "ABTG_RISULTATI\\" + NOMEF + "'")
sost("('ANNO5K_TRE_ANNI_' + (Get-Date)", "('" + NOMEF + "' + (Get-Date)")
# 6. ciclo: modello e periodo per passata, cartella <anno>_M<modello>
sost("$an=$ANNI[$vi]; $bs=Join-Path $OUT $an;", "$an=$ANNI[$vi]; $mo=$MOD[$vi]; $pdg=$PER[$vi]; $bs=Join-Path $OUT ($an + '_M' + $mo);")
sost("conto vuoto 5000 EUR, H1, Modello 1')", "conto vuoto 80000 EUR, ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello 1 -Periodo H1 -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Base $bs", 0)
sost("(' + $ANNI.Count + '", "(' + $ANNI.Count + '") if False else None
sost("'ABTG_RISULTATI\\ANNO80K_TRE_EA_<data>", "'ABTG_RISULTATI\\ANNO80K_TRE_EA_<data>") if False else None
t = t.replace("i 9 EA devono essere gia installati", "gli EA indicati devono essere gia installati")
t = t.replace('(5000 EUR)', '(80000 EUR)').replace('DEEP5K', 'ANNO80K')
open('righe/RIGA_LANCIA_GOLDBOT_TRE_ANNI_80K.txt' if GB else 'righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', 'w', encoding='ascii').write(t)
print('scritta, byte', len(t), 'sha script', sh[:8], 'runs', len(runs))
