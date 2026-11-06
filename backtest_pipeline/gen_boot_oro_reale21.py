#!/usr/bin/env python3
"""Riga CORTA (bootstrap) del trio oro a 4 livelli: scarica dal commit inchiodato RIGA_LANCIA_ORO_REALE21.txt, verifica SHA256, una riga sola e marcatore, poi la esegue.
Modello: righe/BOOT_RIGA_WIM_FOREX_4K.txt. Uso: python3 gen_boot_oro_gradini.py <PIN40 della riga lunga> <SHA256 della riga lunga>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/BOOT_RIGA_WIM_FOREX_4K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost("9b00d94809ce04b42d34bd789e777e2730db8a9e", PIN)
sost("D99D6C08AD124495B0182FB9A4A6AA32CDD22C790B28C92A866BA8910BE20140", SHA)
sost("RIGA_LANCIA_WIM_FOREX_4K.txt", "RIGA_LANCIA_ORO_REALE21.txt", t.count("RIGA_LANCIA_WIM_FOREX_4K.txt"))
i = t.index("Write-Host 'BERSAGLIO:"); j = t.index("' -ForegroundColor Yellow;", i)
testo = ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ, con MT5 CHIUSO (tutti e QUATTRO: BCM, C:\\MT5_Backtest, C:\\FundedNext_Manuale e C:\\MT5_Backtest\\Mt5_Ftmo_Prova). Questa e la riga CORTA del TRIO ORO di Wim sul CONTO REALE (3745 EUR): Reaper, Phantom, Goldbot One a quattro livelli di rischio, 21 mesi continui 2025-01 / 2026-10, 21 passate (12 a Modello 1, poi 9 a tick reali), solo tester, terminale BCM demo 50503392 del PC di backtest. Scarica dal commit inchiodato " + PIN[:8] + " la riga lunga RIGA_LANCIA_ORO_REALE21.txt (23 KB, passata dal cancello), ne verifica SHA256, una riga sola e marcatore, e la esegue cosi come e, senza modificarla. Serve il file combodeal.zip di Wim sul Desktop, in Download o in Documenti: se non c e, la riga lunga si ferma subito. Le guardie operative stanno nella riga lunga. NON TOCCATI, per nome: il VPS VMI3047753 e TUTTE le sue cartelle dati, il REALE 10105439, nessun ordine vero. Criteri e previsioni: report/CRITERI_ORO_REALE21_2026-11-06.md. NON e collaudata da agenti: ha passato SOLO il cancello meccanico e il mio controllo.")
t = t[:i] + "Write-Host '" + testo + t[j:]
open('righe/BOOT_RIGA_ORO_REALE21.txt', 'w', encoding='ascii').write(t)
print('boot', len(t))
