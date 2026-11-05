#!/usr/bin/env python3
"""Riga unica: i DUE Bitcoin di Wim (Bitcoin Scalp Pro, Bitcoin Reaper), tutti i loro set, su BTCUSD H1, 80.000 EUR, sul terminale di PROVA FTMO (C:\\MT5_FTMO_PROVA, sola lettura).
Parte dalla riga del pacchetto Wim (righe/RIGA_LANCIA_WIM_PACCHETTO_80K.txt) e ne cambia bersaglio, tabella delle passate e script.
Uso: python3 gen_riga_btc_ftmo_80k.py <PIN40> <SHA256 di righe/ANNO80K_WIM_FTMO_TESTER.ps1>"""
import sys, os, re
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/RIGA_LANCIA_WIM_PACCHETTO_80K.txt', encoding='ascii').read()
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:90])
    t = t.replace(a, b)
ANNI = ['2025', '2024', '2023', '2022', '2021', '2020', '2019', '2018']   # dal piu recente: se manca la storia, lo si vede subito
EA = [
 ('Bitcoin_Scalp_pro_MT5_WSC_V2.4.ex5', 'Bitcoin-Scalp-Pro-Set-Files.zip', 'BSP', ['1% risk per trade_low risk.set', '2% risk per trade_medium risk.set', 'BitcoinScalpPro_PropFirm.set']),
 ('Bitcoin_Reaper_V3.6_WSC.ex5', 'Bitcoin-Reaper-Set-Files.zip', 'BRP', ['Bitcoin Reaper_LowRisk.set', 'Bitcoin Reaper_MediumRisk.set', 'Bitcoin Reaper_HighRisk.set', 'Bitcoin Reaper_Prop_Firm.set']),
]
runs = []
for ex5, zp, tag, sets in EA:
    for s in sets:
        for a in ANNI:
            lab = tag + '_' + re.sub(r'[^A-Za-z0-9]+', '', s.replace('.set', ''))[:30] + '_' + a
            runs.append((ex5, zp, a, s, lab))
N = len(runs)
q = lambda L: ','.join("'" + x.replace("'", "''") + "'" for x in L)
assert all(re.fullmatch(r"[\x20-\x7E]*", x) for r in runs for x in r)
arrays = ("$fare=@(" + q([r[0] for r in runs]) + "); $ZIPR=@(" + q([r[1] for r in runs]) + "); $ANNI=@(" + q([r[2] for r in runs]) +
          "); $FINR=@(" + q([''] * N) + "); $PER=@(" + q(['H1'] * N) + "); $SETR=@(" + q([r[3] for r in runs]) +
          "); $IMPR=@(" + q([''] * N) + "); $ETI=@(" + q([r[4] for r in runs]) + "); $MOD=@(" + q(['1'] * N) +
          "); $SIMR=@(" + q(['BTCUSD'] * N) + "); $vi=0; $skipEA=@{}; $nok=@{}; $nfail=@{}; ")
a = t.index('$fare=@('); b = t.index('$tutti=@(')
t = t[:a] + arrays + t[b:]
i = t.index("Write-Host 'PACCHETTO WIM"); j = t.index("' -ForegroundColor Cyan;", i)
testa = ("BITCOIN WIM SU TERMINALE FTMO DI PROVA (80.000 EUR, SOLO TESTER): Bitcoin Scalp Pro (3 set) e Bitcoin Reaper (4 set) del venditore, " + str(N) + " passate a Modello 1 (barre da 1 minuto), BTCUSD H1, anni 2025, 2024, 2023, 2022, 2021, 2020, 2019, 2018 (scelti PRIMA dei numeri: dal piu recente, un anno al ribasso, uno al rialzo e uno laterale se la storia c e; gli anni senza storia escono come passate KO nel manifest). Terminale C:\\MT5_FTMO_PROVA, FTMO-Demo, conto 1515150476 in SOLA LETTURA (password investitore). Criteri e previsioni scritti prima: report/UBS_PACCHETTO_WIM/CRITERI_BTC_FTMO_2026-11-05.md. Non giudica acquisti, taglie o rischio.")
t = t[:i] + "Write-Host '" + testa + t[j:]
sost("terminale C:\\Program Files\\BCM Markets MT5 Terminal (cartella BCM Markets MT5 Terminal), loggato sul demo 50503392 di QUESTO PC.",
     "terminale C:\\MT5_FTMO_PROVA (FTMO-Demo, conto 1515150476 in SOLA LETTURA con password investitore: NON puo aprire ordini; e lo stesso conto delle sedie sul VPS, che NON viene toccato).")
sost("gli .ex5 del pacchetto Wim devono stare in C:\\Program Files\\BCM Markets MT5 Terminal > File > Apri cartella dati > MQL5 > Experts (anche in una sottocartella, per esempio Wim), UNA copia sola ciascuno; gli ZIP dei set (Apex-Set-Files.zip, Stability-Pro-Set-Files.zip, Luna-Set-Files.zip, Daytrade-Pro-Set-Files.zip, ORB-Master-Set-Files.zip, Indicement-Set-Files.zip)",
     "i due .ex5 Bitcoin (Bitcoin_Scalp_pro_MT5_WSC_V2.4.ex5 e Bitcoin_Reaper_V3.6_WSC.ex5) devono stare nel terminale C:\\MT5_FTMO_PROVA > File > Apri cartella dati > MQL5 > Experts (anche in una sottocartella, per esempio Wim), UNA copia sola ciascuno; gli ZIP dei set (Bitcoin-Scalp-Pro-Set-Files.zip, Bitcoin-Reaper-Set-Files.zip)")
sost("chiudi A MANO SOLO il terminal64 con cartella C:\\Program Files\\BCM Markets MT5 Terminal. Qui ci sono TRE MT5 (C:\\Program Files\\BCM Markets MT5 Terminal = demo 50503392, C:\\MT5_Backtest, C:\\FundedNext_Manuale): devono essere tutti chiusi.",
     "chiudi A MANO SOLO il terminal64 con cartella C:\\MT5_FTMO_PROVA. Qui ci sono QUATTRO MT5 (C:\\MT5_FTMO_PROVA = FTMO-Demo in sola lettura, C:\\Program Files\\BCM Markets MT5 Terminal, C:\\MT5_Backtest, C:\\FundedNext_Manuale): devono essere tutti chiusi.")
sost("($inst='C:\\Program Files\\BCM Markets MT5 Terminal'))){ throw 'il terminale BCM del PC di backtest non e dove la riga lo aspetta: nessun",
     "($inst='C:\\MT5_FTMO_PROVA'))){ throw 'il terminale C:\\MT5_FTMO_PROVA non e dove la riga lo aspetta: nessun")
sost("terminal64 con cartella C:\\Program Files\\BCM Markets MT5 Terminal.' -ForegroundColor Red; $rest", "terminal64 con cartella C:\\MT5_FTMO_PROVA.' -ForegroundColor Red; $rest")
sost("$SN='ANNO80K_WIM_TESTER.ps1'", "$SN='ANNO80K_WIM_FTMO_TESTER.ps1'")
sost("$MA='MARCATORE_ANNO80K_WIM_TESTER_v1'", "$MA='MARCATORE_ANNO80K_WIM_FTMO_TESTER_v1'")
t = re.sub(r"\$SH='[0-9A-F]{64}'", lambda m: "$SH='" + SHA + "'", t, count=1)
t = re.sub(r"\$PIN='[0-9a-f]{40}'", lambda m: "$PIN='" + PIN + "'", t, count=1)
t = t.replace("ANNO80K_WIM_PACCHETTO_", "ANNO80K_BTC_FTMO_")
t = t.replace("Nessuno degli .ex5 del pacchetto Wim e in MQL5\\Experts di questo terminale", "Nessuno dei due .ex5 Bitcoin e in MQL5\\Experts del terminale C:\\MT5_FTMO_PROVA")
open('righe/RIGA_LANCIA_BTC_FTMO_80K.txt', 'w', encoding='ascii').write(t)
print('scritta', len(t), 'passate', N)
