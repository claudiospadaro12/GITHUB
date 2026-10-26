#!/usr/bin/env python3
"""Deriva righe/RIGA_LANCIA_FOREX_UNICA_80K.txt (10 passate, EA forex del venditore, 2025, 80.000 EUR) dalla riga a 3 EA (ANNO80K, gia passata dal cancello). Uso: python3 gen_riga_unica_80k.py <PIN40>"""
import sys, re, os, subprocess, glob
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
def leggi_set(f):
    b = open(f, 'rb').read(); x = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')
    return {l.split('=', 1)[0].strip(): l.split('=', 1)[1].split('||')[0].strip() for l in x.splitlines() if '=' in l and not l.startswith(';') and ',' not in l.split('=', 1)[0]}
A = {k: leggi_set('set_venditore/apex_trader_v1_90/Apex_%s.set' % k) for k in ('ConservativeGrid', 'ElevatedGrid', 'OptimalGrid', 'Ultra_ConservativeGrid', 'extreme_risk')}
var = lambda k: A[k]['LotsizeVariation'].strip(';').replace(';', '+'); stp = lambda k: A[k]['LotsizeStep']
LUNA, STAB, APEX = 'Luna AI Pro MT5.ex5', 'Stability Pro MT5.ex5', 'Apex Trader MT5.ex5'
AB = 'RunOneChartSetup=true:b;AutoLotMode=3:i;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;'
LB = 'RunOneChartSetup=true:b;AutoLotMode=3:i;AutoGMT=false:b;GMT_Offset_Winter=1:i;GMT_Offset_Summer=1:i;EnableNewsFilter=false:b;OneChartSetup_Pairs=EURAUD+GBPAUD+GBPCHF:s;LotsizeStep='
SB = 'RunOneChartSetup=true:b;AutoLotMode=2:i;AutoLotsizeRisk='
ap = lambda k, lab: (APEX, '2025', '4', 'M15', 'EURUSD', AB + 'LotsizeStep=%s:i;LotsizeVariation=%s:s' % (stp(k), var(k)), '2025_M4_APEX_' + lab)
# ordine di priorita: se la riga si ferma, i primi risultati sono i piu utili
runs = [(APEX, '2025', '4', 'M15', 'EURUSD', AB + 'LotsizeStep=15000:i;LotsizeVariation=' + var('OptimalGrid') + ':s', '2025_M4_APEX_OPT_LS15000'),
        ap('ElevatedGrid', 'ELEVATED_LS%s' % stp('ElevatedGrid')),
        (LUNA, '2025', '4', 'M5', 'EURUSD', LB + '400:i', '2025_M4_LUNA_LS400'),
        (STAB, '2025', '1', 'M5', 'EURUSD', SB + '5:i', '2025_M1_STAB_R5'),
        ap('OptimalGrid', 'OPTIMAL_LS%s' % stp('OptimalGrid')),
        (LUNA, '2025', '4', 'M5', 'EURUSD', LB + '100:i', '2025_M4_LUNA_LS100'),
        (STAB, '2025', '1', 'M5', 'EURUSD', SB + '1:i', '2025_M1_STAB_R1'),
        ap('ConservativeGrid', 'CONSERVATIVE_LS%s' % stp('ConservativeGrid')),
        ap('Ultra_ConservativeGrid', 'ULTRA_LS%s' % stp('Ultra_ConservativeGrid')),
        ap('extreme_risk', 'EXTREME_LS%s' % stp('extreme_risk'))]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("RIGA UNICA, SENZA SORVEGLIANZA: 10 PASSATE DEGLI EA FOREX DEL PACCHETTO A 80.000 EUR, ANNO 2025 (Luna AI Pro, Stability Pro, Apex Trader). Sono EA da forex (sull oro 0 operazioni), si testano su EURUSD con OneChartSetup (Luna e Stability su M5, Apex su M15, come dicono pagine e manuali del venditore, letti da Claudio il 26/10). Ogni passata e a conto vuoto da 80000 EUR, 01/01/2025-01/01/2026, leva 1:100, coppie: Luna EURAUD+GBPAUD+GBPCHF (set raccomandato del venditore), Stability Pro e Apex AUDCAD+AUDNZD+NZDCAD (default). Ordine di priorita (se la riga si ferma, i primi risultati sono i piu utili): (1) Apex griglia ottimale con LotsizeStep 15000 (il valore consigliato dal manuale sopra 15.000 USD); (2) Apex Elevated (3000); (3) Luna LotsizeStep 400; (4) Stability Pro rischio 5; (5) Apex Optimal (7500); (6) Luna LotsizeStep 100; (7) Stability Pro rischio 1; (8) Apex Conservative (2000); (9) Apex Ultra conservative (2000); (10) Apex Extreme risk (5000). Luna e Apex a tick reali (Modello 4), Stability Pro a Modello 1 (il venditore dice che usa solo i prezzi di apertura). Input imposti: RunOneChartSetup=true; AutoLotMode=3 (LotsizeStep) per Luna e Apex e 2 (rischio automatico, INFERITO) per Stability Pro, perche il default AutoLotMode=1 e il lotto fisso 0,01; AutoGMT=false con offset 1/1 (BCM e UTC+1 fisso); Luna: filtro news spento (calendario inesistente nel tester, NON simulato) e coppie del set; Apex: LotsizeStep e LotsizeVariation presi alla lettera dai file .set del venditore (la progressione dei lotti per livello: Ultra 1; Conservative 1;1;2; Elevated 1;2;2;2;3...; Optimal ed Extreme 1;3;5;...;41); gli altri input sono i default (il killswitch sul DD storico in pip di Apex resta ACCESO, MaxAllowedDD spento). SONO MISURE, non scelte di rischio per un conto vero. PRIMA DI LANCIARE: nella Panoramica del mercato del terminale BCM devono essere VISIBILI EURUSD, EURAUD, GBPAUD, GBPCHF, AUDCAD, AUDUSD, AUDNZD, NZDCAD. TEMPO: NON MISURATO su questi EA, multi-simbolo a tick reali per un anno: da 1 a diverse ore per passata, in tutto possibili 10-30 ore; timeout 420 minuti per passata (se una scade, la riga passa alla successiva). Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO; non usare Sospendi. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito): ogni passata finita e gia in ABTG_RISULTATI. A fine riga, lo zip e evidenziato: mandamelo. Criteri e previsioni: report/FOREX_LUNA_STABILITY_TEST_CRITERI_2026-10-26.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente; MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q([r[1] for r in runs]) + "); $MOD=@(" + q([r[2] for r in runs]) + "); $PER=@(" + q([r[3] for r in runs]) + "); $SIMR=@(" + q([r[4] for r in runs]) + "); $IMPR=@(" + q([r[5] for r in runs]) + "); $ETI=@(" + q([r[6] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 3){ throw 'Mancano EA nel Market di questo terminale (servono Luna AI Pro MT5.ex5, Stability Pro MT5.ex5 e Apex Trader MT5.ex5). Nessun tester e partito.' }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi];")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO80K_FOREX_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO80K_FOREX_' + (Get-Date)")
t = t.replace('gli EA indicati devono essere gia installati', 'Luna AI Pro MT5, Stability Pro MT5 e Apex Trader MT5 devono essere gia installati')
open('righe/RIGA_LANCIA_FOREX_UNICA_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs))
