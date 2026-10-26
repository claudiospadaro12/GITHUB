#!/usr/bin/env python3
"""Deriva righe/RIGA_LANCIA_FOREX_3EA_80K.txt dalla riga a 3 EA (ANNO80K, gia passata dal cancello). Uso: python3 gen_riga_forex_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
LUNA, STAB, APEX = 'Luna AI Pro MT5.ex5', 'Stability Pro MT5.ex5', 'Apex Trader MT5.ex5'
LB = 'RunOneChartSetup=true:b;AutoLotMode=3:i;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;EnableNewsFilter=false:b;OneChartSetup_Pairs=EURAUD+GBPAUD+GBPCHF:s;LotsizeStep='
SB = 'RunOneChartSetup=true:b;AutoLotMode=2:i;AutoLotsizeRisk='
AB = 'RunOneChartSetup=true:b;AutoLotMode=3:i;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;LotsizeStep='
runs = [(LUNA, '2025', '4', 'M5', 'EURUSD', LB + '400:i', '2025_M4_LUNA_LS400'), (LUNA, '2025', '4', 'M5', 'EURUSD', LB + '100:i', '2025_M4_LUNA_LS100'),
        (STAB, '2025', '1', 'M5', 'EURUSD', SB + '5:i', '2025_M1_STAB_R5'), (STAB, '2025', '1', 'M5', 'EURUSD', SB + '1:i', '2025_M1_STAB_R1'),
        (APEX, '2025', '4', 'M15', 'EURUSD', AB + '15000:i', '2025_M4_APEX_LS15000'), (APEX, '2025', '4', 'M15', 'EURUSD', AB + '7500:i', '2025_M4_APEX_LS7500')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("EA FOREX DEL PACCHETTO A 80.000 EUR, ANNO 2025: LUNA AI PRO (2 passate a tick reali), STABILITY PRO (2 passate a Modello 1) e APEX TRADER (2 passate a tick reali, grafico EURUSD M15 come da manuale). Non sono EA da oro (setaccio sull oro: 0 operazioni): secondo le pagine del venditore (lette da Claudio il 26/10) si testano su EURUSD M5 con OneChartSetup abilitato (l EA gira da un solo grafico sulle sue coppie: Stability Pro e Apex Trader AUDCAD, AUDNZD, NZDCAD; Luna AI Pro EURAUD, GBPAUD, AUDCAD, AUDUSD, valori di default degli input). Stability Pro usa solo i prezzi di apertura delle candele: il venditore dice che il Modello 1 (OHLC 1 minuto) basta; Luna vuole i tick reali. Stability Pro e Apex Trader sono GRIGLIE con mediazione (dichiarato dal venditore; Apex di default usa lotti crescenti 0,01/0,03/0,05... e nessuno stop loss per grigia): si misura il flottante, non solo il realizzato. 6 PASSATE a conto vuoto da 80000 EUR, 01/01/2025-01/01/2026: Luna LotsizeStep 400 e 100 con le coppie del set raccomandato; Stability Pro AutoLotsizeRisk 5 (medio, default) e 1 (minimo); Apex Trader LotsizeStep 15000 (il valore che il manuale consiglia per la griglia ottimale sopra 15.000 USD) e 7500 (default). Sono MISURE, non una scelta di rischio per un conto vero. ATTENZIONE: di DEFAULT questi EA hanno AutoLotMode=1, che dai set del venditore risulta essere il LOTTO FISSO 0,01 (i set Apex usano AutoLotMode=3 con LotsizeStep): senza imporre AutoLotMode i LotsizeStep e i rischi sotto sarebbero ignorati. Si impone AutoLotMode=3 (LotsizeStep) per Luna e Apex e AutoLotMode=2 (rischio automatico) per Stability Pro: la corrispondenza dei numeri NON e verificata (INFERITA dai set e dai backtest del venditore) e si controlla dai lotti usati nel report (lotto fisso 0,01 = mappa sbagliata). Input imposti: RunOneChartSetup=true; Luna e Apex: AutoGMT=false con offset 1/1 (BCM e UTC+1 fisso; worldtimeserver non raggiungibile dal tester), EnableNewsFilter=false (calendario inesistente nel tester: filtro news NON simulato), LotsizeStep; Stability Pro: AutoLotsizeRisk; Apex: LotsizeStep; il killswitch sul DD storico in pip di Apex (EnableMaxPipsDD) resta al default acceso, mentre MaxAllowedDD e a zero (spento); tutti gli altri input default. PRIMA DI LANCIARE: nella Panoramica del mercato del terminale BCM devono essere VISIBILI EURUSD, EURAUD, GBPAUD, AUDCAD, AUDUSD, AUDNZD, NZDCAD (anche per Apex) e GBPCHF (il manuale dice che l indicatore Bande di Bollinger da errore se una coppia non e visibile o senza storico). Tempo: da pochi minuti a diverse ore per passata. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito). Mi mandi la cartella ABTG_RISULTATI\\\\ANNO80K_FOREX_<data> (o lo zip finale). Criteri e previsioni: report/FOREX_LUNA_STABILITY_TEST_CRITERI_2026-10-26.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $ETI=@(" + q([r[6] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 3){ throw 'Mancano EA nel Market di questo terminale (servono Luna AI Pro MT5.ex5, Stability Pro MT5.ex5 e Apex Trader MT5.ex5). Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi];")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_FOREX_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_FOREX_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Luna AI Pro MT5, Stability Pro MT5 e Apex Trader MT5 devono essere gia installati')
open('righe/RIGA_LANCIA_FOREX_3EA_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t))
