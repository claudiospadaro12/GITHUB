#!/usr/bin/env python3
"""Superriga: Gold Trade Pro, The Gold Phantom, Stability Pro e The DAX Morning Scalp in un solo giro (71 passate, 80.000 EUR), nell ordine GTP -> Phantom -> Stability -> DAX. Le passate sono quelle ESATTE delle quattro righe gia passate dal cancello (stesse liste, stessi input): qui si rilegge il loro testo e si concatenano. Dopo l ultima passata di ogni EA esce uno zip PARZIALE. Uso: python3 gen_riga_super_80k.py <PIN40>"""
import sys, re, os, subprocess
PIN = sys.argv[1]; os.chdir(os.path.dirname(os.path.abspath(__file__)))
GEN = [('gen_riga_gtp_80k.py', 'RIGA_LANCIA_GTP_80K.txt', 'GTP'), ('gen_riga_phantom_80k.py', 'RIGA_LANCIA_PHANTOM_80K.txt', 'PHANTOM'),
       ('gen_riga_stab_80k.py', 'RIGA_LANCIA_STAB_80K.txt', 'STAB'), ('gen_riga_daxms_80k.py', 'RIGA_LANCIA_DAXMS_80K.txt', 'DAXMS')]
NOMI = ['fare', 'ANNI', 'MOD', 'PER', 'SIMR', 'IMPR', 'FINR', 'ETI']
def leggi(t, nome):
    m = re.search(r"\$" + nome + r"=@\((.*?)\); \$", t, re.S); assert m, nome
    v = m.group(1)
    assert v[0] == "'" and v[-1] == "'"
    return v[1:-1].split("','")
dati = {n: [] for n in NOMI}; grp = []; base = None
for g, f, tag in GEN:
    subprocess.check_call([sys.executable, g, PIN])
    t = open('righe/' + f, encoding='ascii').read()
    if base is None: base = t
    k = None
    for n in NOMI:
        L = leggi(t, n); k = len(L) if k is None else k
        assert len(L) == k, (f, n, len(L), k)
        dati[n] += L
    grp += [tag] * k
n = len(grp)
for nome in NOMI: assert len(dati[nome]) == n, nome
assert all(('_' + tag + '_') in e for tag, e in zip(grp, dati['ETI'])), 'etichetta senza tag'
assert len(set(dati['ETI'])) == n, 'etichette duplicate'
t = base
def sost(a, b):
    global t
    assert t.count(a) == 1, (t.count(a), a[:70])
    t = t.replace(a, b)
q = lambda L: ','.join("'" + x + "'" for x in L)
a = t.index('$fare=@('); b = t.index('$IMP=@{')
t = t[:a] + ''.join("$%s=@(%s); " % (nome, q(dati[nome])) for nome in NOMI) + "$GRP=@(" + q(grp) + "); $vi=0; " + t[b:]
testa = ("SUPERRIGA DEI QUATTRO EA DA MISURARE (80.000 EUR, DEMO, SOLO TESTER): Gold Trade Pro (XAUUSD D1, 20 passate), The Gold Phantom (XAUUSD H1, 21 passate), Stability Pro (EURUSD M5, griglia AUDCAD+AUDNZD+NZDCAD, 20 passate) e The DAX Morning Scalp (D30EUR M15, 10 passate): 71 PASSATE in tutto, ognuna a conto vuoto da 80000 EUR, con ESATTAMENTE le passate e gli input delle quattro righe separate gia controllate (stesse liste, stessi set del venditore, stesse etichette). ORDINE: prima i due del pacchetto Gold (Gold Trade Pro, poi Gold Phantom), poi Stability Pro, per ultimo il DAX. Dopo l ultima passata di ogni EA la riga crea uno ZIP PARZIALE sul Desktop (ANNO80K_GTP_..., ANNO80K_PHANTOM_..., ANNO80K_STAB_..., ANNO80K_DAXMS_...): puoi mandarmelo subito, senza aspettare la fine. Alla fine esce anche lo zip unico con tutto. TEMPO: NON misurato con questi set; stime delle righe separate: Gold Trade Pro 5-9 ore, Phantom 5-8 ore, Stability 2-5 ore, DAX 1-3 ore, cioe da 13 a 25 ore in tutto: NON e detto che finisca in un giorno. Timeout 420 minuti per passata. Se un set manda il conto in stop out la passata finisce prima: e un risultato. Per FERMARLA chiudi la finestra fra una passata e l altra (riga EA finito): gli zip parziali gia usciti restano. Tienilo ACCESO, SBLOCCATO, attaccato alla CORRENTE e con il coperchio APERTO. Criteri e previsioni scritti PRIMA dei numeri: report/GOLD_TRADE_PRO_SET_TRE_ANNI_CRITERI_2026-10-27.md, GOLD_PHANTOM_SET_TRE_ANNI_CRITERI_2026-10-27.md, STABILITY_PRO_LOTSIZESTEP_TRE_ANNI_CRITERI_2026-10-27.md, DAX_MORNING_SCALP_CRITERI_2026-10-27.md. Non giudica acquisti ne taglie. Aspetta da sola la fine di un eventuale giro precedente (per esempio il Daytrade Pro); MT5 deve essere CHIUSO. NON e collaudata da agenti: ha passato SOLO il cancello meccanico controlla_riga.py e il mio controllo.")
i = t.index("Write-Host 'GOLD TRADE PRO CON I SET"); j = t.index("' -ForegroundColor Cyan;", i)
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("if($okl.Count -lt 1){ throw 'Manca Goldtrade Pro nel Market di questo terminale. Nessun tester e partito.' }",
     "if($okl.Count -lt 4){ throw ('Mancano nel Market di questo terminale: ' + ((@($fare | Select-Object -Unique) | Where-Object { $okl -notcontains $_ }) -join ', ') + '. Servono tutti e quattro: nessun tester e partito.') }")
sost("TEMPO: alcune ore in tutto (a Modello 1 una passata annuale dura da pochi minuti a circa un ora); timeout 240 minuti per passata.",
     "TEMPO: da 13 a 25 ore in tutto (stima, non misurata); timeout 420 minuti per passata.")
sost("Gold Trade Pro deve essere gia installato (demo del Market)", "Gold Trade Pro, The Gold Phantom, Stability Pro e The DAX Morning Scalp devono essere gia installati (demo del Market)")
sost("'ANNO80K_GTP_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.zip'", "'ANNO80K_SUPER_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.zip'")
sost("ABTG_RISULTATI\\ANNO80K_GTP_'", "ABTG_RISULTATI\\ANNO80K_SUPER_'")
zp = ("if(($vi -ge $GRP.Count) -or ($GRP[$vi] -ne $GRP[$vi-1])){ $gt=$GRP[$vi-1]; try { $gd=@(Get-ChildItem -LiteralPath $OUT -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like ('*_' + $gt + '_*') } | ForEach-Object { $_.FullName }); "
      "if($gd.Count -gt 0){ $gz=Join-Path (Split-Path $OUT -Parent) ('ANNO80K_' + $gt + '_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.zip'); Compress-Archive -Path $gd -DestinationPath $gz; Write-Host ('ZIP PARZIALE ' + $gt + ' PRONTO (' + $gd.Count + ' passate): ' + $gz + '   mandamelo pure subito, senza aspettare la fine del giro') -ForegroundColor Black -BackgroundColor Green } } catch { Write-Host ('zip parziale ' + $gt + ' NON creato (' + $_.Exception.Message + '): le cartelle restano in ' + $OUT) -ForegroundColor Red } }; ")
sost("$vi=$vi+1; $rc=$LASTEXITCODE;", "$vi=$vi+1; " + zp + "$rc=$LASTEXITCODE;")
open('righe/RIGA_LANCIA_SUPER_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', n, {g: grp.count(g) for g in dict.fromkeys(grp)})
