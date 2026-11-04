#!/usr/bin/env python3
"""Riga CORTA (bootstrap) da incollare: scarica dal commit inchiodato la riga lunga RIGA_LANCIA_WIM_PACCHETTO_80K.txt, ne verifica SHA256, una riga sola e marcatore, poi la esegue.
Modello: BOOT_RIGA_R255.txt (branch lavoro). Uso: python3 gen_boot_wim_pacchetto_80k.py <PIN40 della riga lunga> <SHA256 della riga lunga> <percorso BOOT_RIGA_R255.txt>"""
import sys, os
PIN, SHA, MOD = sys.argv[1], sys.argv[2].upper(), sys.argv[3]
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open(MOD, encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("0fdb1a9c9293d3836fa434e7c54c2cbd74292dd4", PIN, t.count("0fdb1a9c9293d3836fa434e7c54c2cbd74292dd4"))
sost("ECCE9C930D64C994D34E3A9A0280D27F902BA8DE7B1536CA1CCF5086AE26AA1F", SHA)
sost("RIGA_R255_SHORT_DOW_INFASE.txt", "RIGA_LANCIA_WIM_PACCHETTO_80K.txt", t.count("RIGA_R255_SHORT_DOW_INFASE.txt"))
sost("MARCATORE_RIGA_ROUND_VPS_v2", "MARCATORE_ANNO80K_WIM_TESTER_v1", t.count("MARCATORE_RIGA_ROUND_VPS_v2"))
i = t.index("Write-Host 'BERSAGLIO:"); j = t.index("' -ForegroundColor Yellow;", i)
testo = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ, con MT5 CHIUSO. Questa e la riga CORTA del PACCHETTO WIM (6 EA, 28 set del venditore, 88 passate a 80.000 EUR, solo tester): scarica dal commit inchiodato " + PIN[:8] + " la riga lunga RIGA_LANCIA_WIM_PACCHETTO_80K.txt (36 KB, passata dal cancello), ne verifica SHA256, una riga sola e marcatore, e la esegue cosi come e, senza modificarla. Le guardie operative (MT5 chiuso, nessun processo chiuso, bersaglio del tester, terminale BCM del PC di backtest) stanno nella riga lunga. NON TOCCATI, per nome: il VPS VMI3047753 e TUTTE le sue cartelle dati -- FTMO, REALE 10105439, 100k 50504263, piccolo 50503392 sul VPS, manuale 50503635, banco 50504400, Pepperstone, Tickmill. NON lanciarla se un altra riga del tester sta gia girando su questo PC. Questa riga corta NON chiude e NON termina nessun processo: scrive SOLO la propria copia scaricata in %USERPROFILE%\\abtg_round\\RIGA_LANCIA_WIM_PACCHETTO_80K.txt (la copia vecchia con lo stesso nome viene tolta prima).")
t = t[:i] + "Write-Host '" + testo + t[j:]
t = t.replace("La riga lunga scaricata NON porta il marcatore MARCATORE_ANNO80K_WIM_TESTER_v1 dello script di round che deve scaricare", "La riga lunga scaricata NON porta il marcatore MARCATORE_ANNO80K_WIM_TESTER_v1 dello script del tester che deve scaricare")
open('righe/BOOT_RIGA_WIM_PACCHETTO_80K.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
