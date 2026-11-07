#!/usr/bin/env python3
"""Riga unica: i 4 EA FOREX di Wim (Daytrade Pro, Luna AI Pro, Stability Pro, Apex Trader), tutti i set, 5 anni, DEPOSITO 4.000 EUR (taglia del conto reale di Claudio), BCM, solo tester. Uso: python3 gen_riga_wim_forex_oos.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/RIGA_LANCIA_GTP_COMBO_TRE_ANNI_80K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
GMT = 'AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i'
IDX = 'US500_Symbol=SPXUSD:s;US30_Symbol=U30USD:s;NAS100_Symbol=NASUSD:s'
# (nome .ex5, zip dei set, etichetta, grafico, periodo, [set...], imposti, anni)
ANNI5 = [('2024', ''), ('2023', ''), ('2021', ''), ('2019', ''), ('2018', ''), ('2016', ''), ('2014', '')]
ANNI21 = [('2025', '2026.10.01')]
EA = [
 ('DayTradePro_WSC_V4.5.ex5', 'Daytrade-Pro-Set-Files.zip', 'DTP', 'D1', ['Daytrade_Pro_Max9%DD_lowrisk.set', 'Daytrade_Pro_Max20%DD_mediumrisk.set', 'Daytrade_Pro_Max50%DD_highrisk.set'], '', ANNI5),
 ('Luna_AI_PRO_MT5_WSC_1.60.ex5', 'Luna-Set-Files.zip', 'LUNA', 'M5', ['Luna_AI_recommended_lowrisk.set', 'Luna_4%DD.set'], GMT, ANNI5),
 ('Stability_Pro_WSC_V2.0.ex5', 'Stability-Pro-Set-Files.zip', 'STAB', 'M5', ['stability pro low risk set.set', 'stability pro medium-low risk set.set'], '', ANNI5),
 ('ApexTrader_WSC_MT5_V2.0.ex5', 'Apex-Set-Files.zip', 'APEX', 'M15', ['Apex_Ultra_ConservativeGrid.set', 'Apex_ConservativeGrid.set', 'Apex_ElevatedGrid.set'], GMT, ANNI5),
]
runs = []
for ex5, zp, tag, per, sets, imp, anni in EA:
    for s in sets:
        for (a, fine) in anni:
            lab = tag + '_' + re.sub(r'[^A-Za-z0-9]+', '', s.replace('.set', ''))[:30] + '_' + a + ('_21m' if fine else '')
            runs.append((ex5, zp, a, fine, per, s, imp, lab))
N = len(runs)
q = lambda L: ','.join("'" + x.replace("'", "''") + "'" for x in L)
assert all(re.fullmatch(r"[\x20-\x7E]*", x) for r in runs for x in r)
arrays = ("$fare=@(" + q([r[0] for r in runs]) + "); $ZIPR=@(" + q([r[1] for r in runs]) + "); $ANNI=@(" + q([r[2] for r in runs]) +
          "); $FINR=@(" + q([r[3] for r in runs]) + "); $PER=@(" + q([r[4] for r in runs]) + "); $SETR=@(" + q([r[5] for r in runs]) +
          "); $IMPR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $MOD=@(" + q(['1'] * N) +
          "); $SIMR=@(" + q(['EURUSD'] * N) + "); $vi=0; $skipEA=@{}; $nok=@{}; $nfail=@{}; ")
a = t.index('$fare=@('); b = t.index('$IMP=@{'); c = t.index('$tutti=@(')
t = t[:a] + arrays + t[c:]
# testo di apertura
i = t.index("Write-Host 'GOLD TRADE PRO COMBO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("4 EA FOREX DI WIM, FUORI CAMPIONE, ALLA TAGLIA DEL CONTO REALE (4.000 EUR, DEMO, SOLO TESTER): Daytrade Pro, Luna AI Pro, Stability Pro e Apex Trader, 10 set del venditore (i candidati e le zone grigie del giro a 4k), " + str(N) + " passate a Modello 1 (barre da 1 minuto), deposito 4000 EUR, SETTE ANNI NUOVI 2024, 2023, 2021, 2019, 2018, 2016, 2014 (mai usati nei test forex), grafico EURUSD con OneChartSetup dove serve, set del venditore applicati con -SetFile. I set di Wim usano un lotto per saldo pensato per conti piccoli: qui il tester li fa girare alla taglia per cui sono disegnati, dove pesa il lotto minimo 0,01. Criteri e previsioni (giro A): report/CRITERI_FOREX_TESTATO_BENE_2026-11-07.md. Mi mandi la cartella ABTG_RISULTATI\\\\ANNO4K_WIM_FOREX_<data> (o gli zip spezzati). Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("PRIMA DI LANCIARE: Gold Trade Pro deve essere gia installato (demo del Market) su QUESTO terminale; NON attaccarli a nessun grafico.",
     "PRIMA DI LANCIARE: gli .ex5 del pacchetto Wim devono stare in C:\\Program Files\\BCM Markets MT5 Terminal > File > Apri cartella dati > MQL5 > Experts (anche in una sottocartella, per esempio Wim), UNA copia sola ciascuno; gli ZIP dei set (Apex-Set-Files.zip, Stability-Pro-Set-Files.zip, Luna-Set-Files.zip, Daytrade-Pro-Set-Files.zip, ORB-Master-Set-Files.zip, Indicement-Set-Files.zip) sul Desktop o in Download o in Documenti, con il nome originale; NON attaccare nessun EA a un grafico.")
sost("TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.",
     "TEMPO: MOLTE ORE (" + str(N) + " passate, stima 10-20 ore, non misurata); timeout 600 minuti per passata. Puoi fermarla quando vuoi: i risultati delle passate finite restano nelle cartelle sul Desktop. Se per un EA le prime due passate non danno nessun OK, quell EA viene saltato (licenza o dati assenti) e si passa al successivo.")
sost("Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester):",
     "Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester; la copia dei set del venditore, con eventuali nomi di simbolo BCM riscritti, in MQL5\\Profiles\\Tester di questo terminale; la decompressione degli ZIP dei set in abtg_wim_sets nel profilo utente):")
sost("'MQL5\\Experts\\Market'", "'MQL5\\Experts'")
sost("$TO=420;", "$TO=600;")
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO80K_WIM_TESTER.ps1'")
sost("$SH='D2AA1B85FBE16190EDC4F46BD7301D7EDA7CD7F576E5D798C57E8820121D4C1B'", "$SH='" + SHA + "'")
sost("$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'")
sost("$PIN='3e43646db065d2503f084f9e747b84bba9e1e97c'", "$PIN='" + PIN + "'")
t = re.sub(r"if\(\$okl\.Count -lt 1\)\{ throw '[^']*' \}", lambda m: "if($okl.Count -lt 1){ throw 'Nessuno degli .ex5 del pacchetto Wim e in MQL5\\Experts di questo terminale. Nessun tester e partito.' }", t, count=1)
t = t.replace('ANNO80K_GTPCOMBO_ANNI_', 'ANNO4K_WIM_FOREX_OOS_')
t = t.replace("EA .ex5 trovati nel Market di questo terminale", "EA .ex5 trovati in MQL5\\Experts di questo terminale").replace("MANCA nel Market di questo terminale, SALTO", "MANCA in MQL5\\Experts di questo terminale, SALTO")
# cerca e decomprime gli zip dei set (prima del ciclo)
staging = ("$cerca=@([Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Downloads'), (Join-Path $env:USERPROFILE 'Documents')); $SETDIR=Join-Path $env:USERPROFILE 'abtg_wim_sets'; New-Item -ItemType Directory -Force -Path $SETDIR | Out-Null; $zpath=@{}; "
           "foreach($zn in @($ZIPR | Select-Object -Unique)){ $f=$null; $zb=[IO.Path]::GetFileNameWithoutExtension($zn); foreach($c in $cerca){ if((-not $f) -and (Test-Path -LiteralPath $c)){ $g=@(Get-ChildItem -LiteralPath $c -Recurse -Depth 3 -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like ($zb + '*.zip') } | Sort-Object LastWriteTime -Descending | Select-Object -First 1); if($g.Count -gt 0){ $f=$g[0].FullName } } }; "
           "if($f){ $dst=Join-Path $SETDIR $zb; if(Test-Path -LiteralPath $dst){ Remove-Item -LiteralPath $dst -Recurse -Force }; Expand-Archive -LiteralPath $f -DestinationPath $dst -Force; $zpath[$zn]=$dst; Write-Host ('ZIP DEI SET trovato: ' + $f + '  ->  ' + $dst) -ForegroundColor Green } else { Write-Host ('ZIP DEI SET NON TROVATO: ' + $zn + ' (cercato in Desktop, Download e Documenti, fino a 3 livelli di sottocartelle). Le passate di quell EA saranno SALTATE.') -ForegroundColor Red } }; ")
sost("$ris=@(); $rc1=0; foreach($n in $fare){ $ErrorActionPreference='Stop';", staging + "$ris=@(); $rc1=0; foreach($n in $fare){ $ErrorActionPreference='Stop'; "
     "$sf=''; if($zpath.ContainsKey($ZIPR[$vi])){ $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[$vi]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $SETR[$vi] }); if($gg.Count -ge 1){ $sf=$gg[0].FullName } }; "
     "if($skipEA.ContainsKey($n)){ Write-Host ('SALTATA (EA gia escluso): ' + $n + ' ' + $ETI[$vi]) -ForegroundColor Yellow; $ris += ,@(($n + ' ' + $ETI[$vi] + ' SALTATA'), 99); $vi=$vi+1; continue }; "
     "if($sf -eq ''){ Write-Host ('SET NON TROVATO, passata SALTATA: ' + $SETR[$vi] + ' (' + $n + ' ' + $ETI[$vi] + ')') -ForegroundColor Red; $ris += ,@(($n + ' ' + $ETI[$vi] + ' SET MANCANTE'), 98); $nfail[$n]=1+[int]$nfail[$n]; $vi=$vi+1; continue }; ")
sost("-Ex5Nome $n ", "-Ex5Nome $n -SetFile $sf -Deposito 4000 ", 2)
sost("$ris += ,@($n, $rc);", "$ris += ,@(($n + ' ' + $ETI[$vi-1]), $rc); if($rc -eq 0){ $nok[$n]=1 } else { $nfail[$n]=1+[int]$nfail[$n] }; if((-not $nok.ContainsKey($n)) -and ([int]$nfail[$n] -ge 2) -and (-not $skipEA.ContainsKey($n))){ $skipEA[$n]=1; Write-Host ('ATTENZIONE: le prime ' + $nfail[$n] + ' passate di ' + $n + ' non hanno dato nessun OK (licenza, dati o simbolo): il RESTO di questo EA viene SALTATO e si passa al prossimo.') -ForegroundColor Red };")
sost("'#########################################################'", "'#########################################################'", t.count("'#########################################################'"))
sost("foreach($e in $ris){ Write-Host ('passata ' + $e[0] + ' finita: rc ' + $e[1])", "foreach($e in $ris){ Write-Host ('passata ' + $e[0] + ' finita: rc ' + $e[1])")
t = t.replace('80.000 EUR', '4.000 EUR').replace('80000 EUR', '4000 EUR').replace('(80000 EUR)', '(4000 EUR)')
open('righe/RIGA_LANCIA_WIM_FOREX_OOS.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N, 'set', sum(len(e[4]) for e in EA))
