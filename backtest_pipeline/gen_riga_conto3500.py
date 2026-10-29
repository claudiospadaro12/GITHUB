#!/usr/bin/env python3
"""Riga unica: Umbra Vault, Microedge, Gold Snap e SomaGold a 3.500 EUR, corsa continua 01/01/2025-01/10/2026 a tick reali (Modello 4), XAUUSD H1, input come nella corsa a 5.000. Script ANNO3500_TESTER (deposito 3500). Uso: python3 gen_riga_conto3500.py <PIN40> (il pin deve essere un commit che contiene righe/ANNO3500_TESTER.ps1)"""
import sys, re, os, subprocess, hashlib
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
subprocess.check_call([sys.executable, 'gen_riga_tre_anni_80k.py', PIN])
t = open('righe/RIGA_LANCIA_TRE_ANNI_80K_3EA.txt', encoding='ascii').read()
def sost(a, b, tutte=False):
    global t
    assert t.count(a) >= 1, a[:70]
    t = t.replace(a, b) if tutte else t.replace(a, b, 1)
SHA = hashlib.sha256(open('righe/ANNO3500_TESTER.ps1', 'rb').read()).hexdigest().upper()
m = re.search(r"\$SH='([0-9A-F]{64})'", t); assert m
sost("$SN='ANNO80K_TESTER.ps1'", "$SN='ANNO3500_TESTER.ps1'"); sost("$SH='" + m.group(1) + "'", "$SH='" + SHA + "'"); sost("MARCATORE_ANNO80K_TESTER_TRANCHE_v1", "MARCATORE_ANNO3500_TESTER_TRANCHE_v1")
runs = [('Umbra Vault AI EA.ex5', 'EquityGuardEnabled=false:b', '21M_M4_UMBRA'), ('Microedge Neural Matrix EA.ex5', 'propGuard=false:b', '21M_M4_MICROEDGE'),
        ('Gold Snap.ex5', '', '21M_M4_GOLDSNAP'),
        ('SomaGold.ex5', 'AutoGMT=false:b;Broker_GMT_OFFSET_Summer=1:i;Broker_GMT_OFFSET_Winter=1:i;MarginCallProtection=false:b', '21M_M4_SOMAGOLD')]
q = lambda L: ','.join("'" + x + "'" for x in L)
i = t.index("Write-Host 'TRE ANNI DELLO STORICO"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("QUATTRO EA SU UN CONTO REALE PERSONALE DA 3.500 EUR (DEMO, SOLO TESTER): Umbra Vault, Microedge, Gold Snap e SomaGold, UNA corsa CONTINUA ciascuna 01/01/2025 - 01/10/2026, XAUUSD H1, tick reali (Modello 4), DEPOSITO 3500 EUR, leva 1:100 (quella del tester; la leva del conto reale NON e verificata), nessun guardiano. Stessi input della corsa a 5.000 (Umbra EquityGuardEnabled=false, Microedge propGuard=false, SomaGold AutoGMT=false con offset 1 e 1 e MarginCallProtection=false, Gold Snap default): cambia SOLO il deposito. Serve a misurare cosa fa il lotto minimo 0,01 a 3.500 (la stima del 29/10 scalava le corse a 5.000 per 0,7) e a calcolare lo spread pagato. TEMPO: a 5.000 le corse hanno impiegato da pochi minuti a circa un ora; 1-3 ore in tutto; timeout 420 minuti per EA. Criteri e previsioni scritti PRIMA dei numeri: report/CONTO_3500_QUATTRO_EA_CRITERI_2026-10-29.md. Non giudica acquisti ne taglie. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo. MT5 deve essere CHIUSO")
t = t[:i] + "Write-Host '" + testa + t[j:]
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + "$fare=@(" + q([r[0] for r in runs]) + "); $ANNI=@(" + q(['2025'] * 4) + "); $MOD=@(" + q(['4'] * 4) + "); $PER=@(" + q(['H1'] * 4) + "); $SIMR=@(" + q(['XAUUSD'] * 4) + "); $IMPR=@(" + q([r[1] for r in runs]) + "); $FINR=@(" + q(['2026.10.01'] * 4) + "); $ETI=@(" + q([r[2] for r in runs]) + "); $vi=0; " + t[b:]
t, n = re.subn(r"if\(\$okl\.Count -lt \d+\)\{ throw '[^']*' \}", "if($okl.Count -lt 4){ throw ('Mancano nel Market di questo terminale: ' + ((@($fare | Select-Object -Unique) | Where-Object { $okl -notcontains $_ }) -join ', ') + '. Servono tutti e quattro: nessun tester e partito.') }", t, count=1); assert n == 1
sost("$TO=240;", "$TO=420;")
sost("$im=''; if($IMP.ContainsKey($n)){ $im=$IMP[$n] };", "$im=$IMPR[$vi]; $sy=$SIMR[$vi]; $ex=@(); if($FINR[$vi] -ne ''){ $ex=@('-Fine',$FINR[$vi]) };")
sost("$bs=Join-Path $OUT ($an + '_M' + $mo);", "$bs=Join-Path $OUT $ETI[$vi];")
sost("EUR, ' + $pdg + ', Modello ' + $mo)", "EUR, ' + $sy + ' ' + $pdg + ', Modello ' + $mo)")
sost("-Anno $an -Modello $mo -Periodo $pdg -Base $bs", "-Anno $an -Modello $mo -Periodo $pdg -Simbolo $sy -Base $bs @ex", True)
sost("ABTG_RISULTATI\\ANNO80K_TRE_EA_'", "ABTG_RISULTATI\\ANNO3500_QUATTRO_EA_'")
sost("('ANNO80K_TRE_EA_' + (Get-Date)", "('ANNO3500_QUATTRO_EA_' + (Get-Date)")
t = t.replace('80000 EUR', '3500 EUR').replace('80.000 EUR', '3.500 EUR').replace('ANNO80K', 'ANNO3500')
t = t.replace('gli EA indicati devono essere gia installati', 'Umbra Vault, Microedge, Gold Snap e SomaGold devono essere gia installati (demo del Market)')
assert '80000' not in t and 'ANNO80K' not in t
open('righe/RIGA_LANCIA_CONTO3500.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', len(runs), 'sha script', SHA[:8])
