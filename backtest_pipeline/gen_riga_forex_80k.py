#!/usr/bin/env python3
"""Deriva righe/RIGA_LANCIA_FOREX_LUNA_STABILITY_80K.txt dalla riga a 3 EA (ANNO80K, gia passata dal cancello). Uso: python3 gen_riga_forex_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
LUNA, STAB = 'Luna AI Pro MT5.ex5', 'Stability Pro MT5.ex5'
LB = 'RunOneChartSetup=true:b;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;EnableNewsFilter=false:b;LotsizeStep='
SB = 'RunOneChartSetup=true:b;AutoLotsizeRisk='
runs = [(LUNA, '2025', '4', 'M5', 'EURUSD', LB + '400:i', '2025_M4_LUNA_LS400'), (LUNA, '2025', '4', 'M5', 'EURUSD', LB + '200:i', '2025_M4_LUNA_LS200'),
        (STAB, '2025', '1', 'M5', 'EURUSD', SB + '5:i', '2025_M1_STAB_R5'), (STAB, '2025', '1', 'M5', 'EURUSD', SB + '1:i', '2025_M1_STAB_R1')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("EA FOREX DEL PACCHETTO A 80.000 EUR, ANNO 2025: LUNA AI PRO (2 passate a tick reali) e STABILITY PRO (2 passate a Modello 1). Non sono EA da oro (setaccio sull oro: 0 operazioni): secondo le pagine del venditore (lette da Claudio il 26/10) si testano su EURUSD M5 con OneChartSetup abilitato (l EA gira da un solo grafico sulle sue coppie: Stability Pro AUDCAD, AUDNZD, NZDCAD; Luna AI Pro EURAUD, GBPAUD, AUDCAD, AUDUSD, valori di default degli input). Stability Pro usa solo i prezzi di apertura delle candele: il venditore dice che il Modello 1 (OHLC 1 minuto) basta; Luna vuole i tick reali. Stability Pro e una GRIGLIA con mediazione (SVG, Smart Variable Grid, dichiarato dal venditore): si misura il flottante, non solo il realizzato. 4 PASSATE a conto vuoto da 80000 EUR, 01/01/2025-01/01/2026: Luna LotsizeStep 400 (basso) e 200 (medio, default); Stability Pro AutoLotsizeRisk 5 (medio, default) e 1 (minimo). Sono MISURE, non una scelta di rischio per un conto vero. Input imposti: RunOneChartSetup=true; Luna: AutoGMT=false con offset 1/1 (BCM e UTC+1 fisso; worldtimeserver non raggiungibile dal tester), EnableNewsFilter=false (calendario inesistente nel tester: filtro news NON simulato), LotsizeStep; Stability Pro: AutoLotsizeRisk; tutti gli altri input default. PRIMA DI LANCIARE: nella Panoramica del mercato del terminale BCM devono essere VISIBILI EURUSD, EURAUD, GBPAUD, AUDCAD, AUDUSD, AUDNZD, NZDCAD (il manuale dice che l indicatore Bande di Bollinger da errore se una coppia non e visibile o senza storico). Tempo: da pochi minuti a diverse ore per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_FOREX_<data> (o lo zip finale). Criteri e previsioni: report/FOREX_LUNA_STABILITY_TEST_CRITERI_2026-10-26.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $ETI=@(" + q([r[6] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 2){ throw 'Mancano EA nel Market di questo terminale (servono Luna AI Pro MT5.ex5 e Stability Pro MT5.ex5). Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi];")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_FOREX_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_FOREX_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Luna AI Pro MT5 e Stability Pro MT5 devono essere gia installati')
open('righe/RIGA_LANCIA_FOREX_LUNA_STABILITY_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t))
