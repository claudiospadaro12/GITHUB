#!/usr/bin/env python3
"""Riga unica: il TRIO ORO di Wim (The Gold Reaper, The Gold Phantom, Goldbot One) a QUATTRO livelli di rischio (L0 Prop, L1 Gradino 1, L2 Medium, L3 Combo 3GOLD), 4 anni (2013, 2018, 2020, 2025), DUE depositi (80.000 e 3.745 EUR), set ufficiali di combodeal.zip applicati con -SetFile, BCM, solo tester. 96 passate. Criteri: report/CRITERI_ORO_GRADINI_RISCHIO_2026-11-05.md.
Uso: python3 gen_riga_oro_weekend2.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/RIGA_LANCIA_GTP_COMBO_TRE_ANNI_80K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
ZIP = 'combodeal.zip'
EAS = [('The Gold Reaper MT5.ex5', 'H1', 'GR'), ('The Gold Phantom.ex5', 'H1', 'PH'), ('Goldbot One MT5.ex5', 'D1', 'GB')]
# livello -> deposito -> [set Reaper, set Phantom, set Goldbot]
SETS = {
 'L2': {80000: ['gold_reaper_default.set', 'GoldPhantom_MediumRisk.set', 'Goldbot_MediumRisk_Max30DD.set'],
        3745: ['gold_reaper_default.set', 'GoldPhantom_MediumRisk.set', 'Goldbot_MediumRisk_Max30DD.set']},
 'L0': {80000: ['Gold_reaper_propfirm.set', 'GoldPhantom_Propfirm_combo.set', 'Goldbot_PropFirm_5_2.5.set'],
        3745: ['Gold_reaper_propfirm.set', 'GoldPhantom_Propfirm_combo.set', 'Goldbot_PropFirm_5_2.5.set']},
 'L1': {80000: ['gold_reaper_15%maxrisk.set', 'GoldPhantom_Propfirm.set', 'Goldbot_PropFirm_10_5.set'],
        3745: ['gold_reaper_15%maxrisk.set', 'GoldPhantom_Propfirm.set', 'Goldbot_PropFirm_10_5.set']},
 'L3': {80000: ['Gold_reaper_propfirm_combo_3GOLD.set', 'GoldPhantom_Propfirm_combo_3GOLD.set', 'Goldbot_PropFirm_combo_3GOLD.set'],
        3745: ['gold_reaper_3GOLD.set', 'GoldPhantom_3GOLD.set', 'Goldbot_3GOLD.set']},
}
ANNI = ['2013', '2020', '2025']
IMP = 'FridayStopHour=19:i'
runs = []   # (ex5, zip, anno, fine, periodo, set, imposti, etichetta, deposito)
# Reaper e Phantom (Randomization 50 nei set: tester NON deterministico, vedi O-3b): Friday19 x2 ripetizioni + 1 ripetizione del base (nessun input cambiato).
# Goldbot (Randomization 0): deterministico, una sola corsa Friday19.
for liv in ('L0', 'L3'):
    for anno in ANNI:
        for (ex5, per, tag), st in zip(EAS, SETS[liv][80000]):
            if tag == 'GB':
                runs.append((ex5, ZIP, anno, '', per, st, IMP, 'FRI19_R1_%s_%s_80000_%s' % (liv, tag, anno), 80000))
            else:
                for rep in ('R1', 'R2'):
                    runs.append((ex5, ZIP, anno, '', per, st, IMP, 'FRI19_%s_%s_%s_80000_%s' % (rep, liv, tag, anno), 80000))
                runs.append((ex5, ZIP, anno, '', per, st, '', 'BASE_R1_%s_%s_80000_%s' % (liv, tag, anno), 80000))
N = len(runs)
assert N == 42
q = lambda L: ','.join("'" + x.replace("'", "''") + "'" for x in L)
assert all(re.fullmatch(r"[\x20-\x7E]*", str(x)) for r in runs for x in r)
assert len(set(r[7] for r in runs)) == N
arrays = ("$fare=@(" + q([r[0] for r in runs]) + "); $ZIPR=@(" + q([r[1] for r in runs]) + "); $ANNI=@(" + q([r[2] for r in runs]) +
          "); $FINR=@(" + q([r[3] for r in runs]) + "); $PER=@(" + q([r[4] for r in runs]) + "); $SETR=@(" + q([r[5] for r in runs]) +
          "); $IMPR=@(" + q([r[6] for r in runs]) + "); $ETI=@(" + q([r[7] for r in runs]) + "); $DEPR=@(" + q([str(r[8]) for r in runs]) + "); $MOD=@(" + q(['1'] * N) +
          "); $SIMR=@(" + q(['XAUUSD'] * N) + "); $vi=0; $skipEA=@{}; $nok=@{}; $nfail=@{}; ")
a = t.index('$fare=@('); c = t.index('$tutti=@(')
t = t[:a] + arrays + t[c:]
i = t.index("Write-Host 'GOLD TRADE PRO COMBO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("O-2 WEEKEND (versione con RIPETIZIONI): COSTO DELLA CHIUSURA DEL VENERDI. Il TRIO ORO di Wim (The Gold Reaper H1, The Gold Phantom H1, Goldbot One D1, XAUUSD, DEMO, SOLO TESTER) ai livelli L0 Prop e L3 Combo 3GOLD (set UFFICIALI da combodeal.zip), anni 2013, 2020 e 2025, deposito 80000 EUR, Modello 1. FRI19 = FridayStopHour 19 (ora del server; nei test base e 25 = spento) e UN SOLO input cambiato. Reaper e Phantom hanno Randomization 50 (il tester non e deterministico, O-3b): FRI19 in 2 ripetizioni (R1, R2) e in piu 1 ripetizione del BASE (BASE_R1: nessun input cambiato). Goldbot ha Randomization 0: una sola corsa FRI19. 42 passate. Serve a misurare (1) quanto profitto e DD costa fermarsi il venerdi sera rispetto al rumore, (2) se il parametro CHIUDE le posizioni o blocca solo le nuove (NON VERIFICATO). Criteri e previsioni: report/CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md (O-2, con la revisione del 09/11). Mi mandi la cartella ABTG_RISULTATI\\\\ANNO_ORO_GRADINI_WEEKEND2_<data> (o gli zip spezzati). Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("PRIMA DI LANCIARE: Gold Trade Pro deve essere gia installato (demo del Market) su QUESTO terminale; NON attaccarli a nessun grafico.",
     "PRIMA DI LANCIARE: The Gold Reaper, The Gold Phantom e Goldbot One devono essere gia installati (Market) su QUESTO terminale, UNA copia sola ciascuno; il file combodeal.zip (il pacchetto ufficiale di Wim) deve stare sul Desktop o in Download o in Documenti, con il nome originale; NON attaccare nessun EA a un grafico.")
sost("TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.",
     "TEMPO: MOLTE ORE (" + str(N) + " passate, stima 6-8 ore, non misurata); timeout 90 minuti per passata (NON 600). Se la finestra Salvataggio report resta ferma oltre 20 minuti, chiudi A MANO il terminale BCM (Task Manager > Dettagli > terminal64.exe di C:\\\\Program Files\\\\BCM Markets MT5 Terminal, SOLO quello). Se per un EA le prime due passate non danno nessun OK, quell EA viene saltato e si passa al successivo. Se combodeal.zip non si trova, la riga si FERMA subito con un messaggio rosso: controlla le prime righe appena lanciata.")
sost("Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester):",
     "Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester; la copia dei set del venditore in MQL5\\Profiles\\Tester di questo terminale; la decompressione di combodeal.zip in abtg_wim_sets nel profilo utente):")
sost("'MQL5\\Experts\\Market'", "'MQL5\\Experts'")
sost("$TO=420;", "$TO=90;")
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO80K_WIM_TESTER.ps1'")
sost("$SH='D2AA1B85FBE16190EDC4F46BD7301D7EDA7CD7F576E5D798C57E8820121D4C1B'", "$SH='" + SHA + "'")
sost("$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'")
sost("$PIN='3e43646db065d2503f084f9e747b84bba9e1e97c'", "$PIN='" + PIN + "'")
t = re.sub(r"if\(\$okl\.Count -lt 1\)\{ throw '[^']*' \}", lambda m: "if($okl.Count -lt 3){ throw 'Mancano uno o piu EA oro (The Gold Reaper MT5.ex5, The Gold Phantom.ex5, Goldbot One MT5.ex5) in MQL5\\Experts di questo terminale. Nessun tester e partito.' }", t, count=1)
t = t.replace('ANNO80K_GTPCOMBO_ANNI_', 'ANNO_ORO_GRADINI_WEEKEND2_')
t = t.replace("EA .ex5 trovati nel Market di questo terminale", "EA .ex5 trovati in MQL5\\Experts di questo terminale").replace("MANCA nel Market di questo terminale, SALTO", "MANCA in MQL5\\Experts di questo terminale, SALTO")
staging = ("$cerca=@([Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Downloads'), (Join-Path $env:USERPROFILE 'Documents')); $SETDIR=Join-Path $env:USERPROFILE 'abtg_wim_sets'; New-Item -ItemType Directory -Force -Path $SETDIR | Out-Null; $zpath=@{}; "
           "foreach($zn in @($ZIPR | Select-Object -Unique)){ $f=$null; $zb=[IO.Path]::GetFileNameWithoutExtension($zn); foreach($c in $cerca){ if((-not $f) -and (Test-Path -LiteralPath $c)){ $g=@(Get-ChildItem -LiteralPath $c -Recurse -Depth 3 -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like ($zb + '*.zip') } | Sort-Object LastWriteTime -Descending | Select-Object -First 1); if($g.Count -gt 0){ $f=$g[0].FullName } } }; "
           "if($f){ $dst=Join-Path $SETDIR $zb; if(Test-Path -LiteralPath $dst){ Remove-Item -LiteralPath $dst -Recurse -Force }; Expand-Archive -LiteralPath $f -DestinationPath $dst -Force; $zpath[$zn]=$dst; Write-Host ('ZIP DEI SET trovato: ' + $f + '  ->  ' + $dst) -ForegroundColor Green } else { Write-Host ('ZIP DEI SET NON TROVATO: ' + $zn + ' (cercato in Desktop, Download e Documenti, fino a 3 livelli di sottocartelle).') -ForegroundColor Red } }; "
           "if($zpath.Count -lt 1){ Write-Host 'MI FERMO: combodeal.zip non si trova sul Desktop, in Download o in Documenti di questo PC. Mettilo li (e un file di Wim, lo stesso che mi hai mandato) e rilancia. Nessun tester e partito.' -ForegroundColor Red; return }; "
           "foreach($sn in @($SETR | Select-Object -Unique)){ $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[0]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $sn }); if($gg.Count -ne 1){ Write-Host ('MI FERMO: nel pacchetto il set ' + $sn + ' risulta ' + $gg.Count + ' volte (ne serve UNA). Nessun tester e partito.') -ForegroundColor Red; return } }; ")
sost("$ris=@(); $rc1=0; foreach($n in $fare){ $ErrorActionPreference='Stop';", staging + "$ris=@(); $rc1=0; foreach($n in $fare){ $ErrorActionPreference='Stop'; "
     "$sf=''; if($zpath.ContainsKey($ZIPR[$vi])){ $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[$vi]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $SETR[$vi] }); if($gg.Count -ge 1){ $sf=$gg[0].FullName } }; "
     "if($skipEA.ContainsKey($n)){ Write-Host ('SALTATA (EA gia escluso): ' + $n + ' ' + $ETI[$vi]) -ForegroundColor Yellow; $ris += ,@(($n + ' ' + $ETI[$vi] + ' SALTATA'), 99); $vi=$vi+1; continue }; "
     "if($sf -eq ''){ Write-Host ('SET NON TROVATO, passata SALTATA: ' + $SETR[$vi] + ' (' + $n + ' ' + $ETI[$vi] + ')') -ForegroundColor Red; $ris += ,@(($n + ' ' + $ETI[$vi] + ' SET MANCANTE'), 98); $nfail[$n]=1+[int]$nfail[$n]; $vi=$vi+1; continue }; ")
sost("-Ex5Nome $n ", "-Ex5Nome $n -SetFile $sf -Deposito $($DEPR[$vi]) ", 2)
sost("$ris += ,@($n, $rc);", "$ris += ,@(($n + ' ' + $ETI[$vi-1]), $rc); if($rc -eq 0){ $nok[$n]=1 } else { $nfail[$n]=1+[int]$nfail[$n] }; if((-not $nok.ContainsKey($n)) -and ([int]$nfail[$n] -ge 2) -and (-not $skipEA.ContainsKey($n))){ $skipEA[$n]=1; Write-Host ('ATTENZIONE: le prime ' + $nfail[$n] + ' passate di ' + $n + ' non hanno dato nessun OK (licenza, dati o simbolo): il RESTO di questo EA viene SALTATO e si passa al prossimo.') -ForegroundColor Red };")
sost("conto vuoto 80000 EUR, ' + $sy", "conto vuoto ' + $DEPR[$vi] + ' EUR, ' + $sy")
sost("passate da fare a 80000 EUR: ", "passate da fare (deposito 80000 o 3745 EUR a seconda della passata): ")
t = t.replace('80.000 EUR', 'deposito 80000 o 3745 EUR').replace('80000 EUR', 'deposito 80000 o 3745 EUR')
open('righe/RIGA_LANCIA_ORO_WEEKEND2.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N)
