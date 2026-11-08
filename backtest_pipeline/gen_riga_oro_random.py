#!/usr/bin/env python3
"""Riga unica: il TRIO ORO di Wim (The Gold Reaper, The Gold Phantom, Goldbot One) a QUATTRO livelli di rischio (L0 Prop, L1 Gradino 1, L2 Medium, L3 Combo 3GOLD), 4 anni (2013, 2018, 2020, 2025), DUE depositi (80.000 e 3.745 EUR), set ufficiali di combodeal.zip applicati con -SetFile, BCM, solo tester. 96 passate. Criteri: report/CRITERI_ORO_GRADINI_RISCHIO_2026-11-05.md.
Uso: python3 gen_riga_oro_random.py <PIN40> <SHA256 di righe/ANNO80K_WIM_TESTER.ps1 a quel pin>"""
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
runs = []   # (ex5, zip, anno, fine, periodo, set, imposti, etichetta, deposito)
for rnd in ('0', '60'):
    for anno in ANNI:
        for (ex5, per, tag), s in zip(EAS, SETS['L0'][80000]):
            if tag in ('GR', 'PH'):
                runs.append((ex5, ZIP, anno, '', per, s, 'Randomization=%s:d' % rnd, 'RND%s_L0_%s_80000_%s' % (rnd, tag, anno), 80000))
N = len(runs)
assert N == 12
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
testa = ("O-3 RANDOMIZATION: Reaper H1 e Phantom H1 (XAUUSD, DEMO, SOLO TESTER) al livello Prop (L0, set UFFICIALI di combodeal.zip, che hanno Randomization 50), anni 2013, 2020, 2025, deposito 80000 EUR, Modello 1, con UN SOLO input cambiato: Randomization 0 oppure 60. 12 passate (2 EA x 3 anni x 2 valori). Il riferimento con 50 e nei 96 test gia fatti. Serve a misurare se la Randomization costa profitto o cambia il DD o il numero di operazioni. Criteri e previsioni: report/CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md (O-3). Mi mandi la cartella ABTG_RISULTATI\\\\ANNO_ORO_GRADINI_RANDOM_<data> (o gli zip spezzati). Non giudica acquisti, taglie ne lotti. MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("PRIMA DI LANCIARE: Gold Trade Pro deve essere gia installato (demo del Market) su QUESTO terminale; NON attaccarli a nessun grafico.",
     "PRIMA DI LANCIARE: The Gold Reaper, The Gold Phantom e Goldbot One devono essere gia installati (Market) su QUESTO terminale, UNA copia sola ciascuno; il file combodeal.zip (il pacchetto ufficiale di Wim) deve stare sul Desktop o in Download o in Documenti, con il nome originale; NON attaccare nessun EA a un grafico.")
sost("TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.",
     "TEMPO: MOLTE ORE (" + str(N) + " passate, stima 1-2 ore, non misurata); timeout 90 minuti per passata (NON 600). Se la finestra Salvataggio report resta ferma oltre 20 minuti, chiudi A MANO il terminale BCM (Task Manager > Dettagli > terminal64.exe di C:\\\\Program Files\\\\BCM Markets MT5 Terminal, SOLO quello). Se per un EA le prime due passate non danno nessun OK, quell EA viene saltato e si passa al successivo. Se combodeal.zip non si trova, la riga si FERMA subito con un messaggio rosso: controlla le prime righe appena lanciata.")
sost("Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester):",
     "Scrive SOLO (oltre ai file che MT5 scrive da se: log, storico, cache del tester; la copia dei set del venditore in MQL5\\Profiles\\Tester di questo terminale; la decompressione di combodeal.zip in abtg_wim_sets nel profilo utente):")
sost("'MQL5\\Experts\\Market'", "'MQL5\\Experts'")
sost("$TO=420;", "$TO=90;")
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO80K_WIM_TESTER.ps1'")
sost("$SH='D2AA1B85FBE16190EDC4F46BD7301D7EDA7CD7F576E5D798C57E8820121D4C1B'", "$SH='" + SHA + "'")
sost("$MA='MARCATORE_ANNO80K_TESTER_TRANCHE_v1'", "$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'")
sost("$PIN='3e43646db065d2503f084f9e747b84bba9e1e97c'", "$PIN='" + PIN + "'")
t = re.sub(r"if\(\$okl\.Count -lt 1\)\{ throw '[^']*' \}", lambda m: "if($okl.Count -lt 3){ throw 'Mancano uno o piu EA oro (The Gold Reaper MT5.ex5, The Gold Phantom.ex5, Goldbot One MT5.ex5) in MQL5\\Experts di questo terminale. Nessun tester e partito.' }", t, count=1)
t = t.replace('ANNO80K_GTPCOMBO_ANNI_', 'ANNO_ORO_GRADINI_RANDOM_')
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
open('righe/RIGA_LANCIA_ORO_RANDOM.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N)
