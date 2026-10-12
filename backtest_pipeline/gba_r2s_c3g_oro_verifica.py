#!/usr/bin/env python3
"""GBA R2S stadio A -- ricontrollo dei numeri C3G dell'ORO citati nel pacchetto per Gemini (12/10/2026).

BOZZA, NON passata dal cancello, NON e' lo strumento D2 (che deve leggere i giornali delle passate nuove e passare
dal cancello prima di aprire lo zip). Serve solo a rifare i numeri della sonda precedente sull'oro, indipendenti dal
lettore leggi_gba_r0.py: C3G = mediana del campo 'stop/spread' di TUTTE le righe segnale del giornale della passata
(le righe -1.0x = spread zero valgono infinito), per cella, lato, fascia e fascia x lato; quota di righe >= 50x e
ingressi (righe non SALTATO) per fascia. Sola lettura di due zip gia' in repo.
Uso: python3 -I backtest_pipeline/gba_r2s_c3g_oro_verifica.py
"""
import re, statistics as S, zipfile

S0 = ("backtest_pipeline/risultati_archivio/GBA_R0_S0_20261010/GBA_R0_S0.zip", "log\\GBA_S0_01_REPL_T1_m775800.txt", "S0 Modello 1")
R1A = ("backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip", "log\\GBA_R1A_01_REPL_T1_m775800.txt", "R1A tick reali")
FASCE = [(0, 7, "asia"), (7, 12, "europa"), (12, 14, "pausa"), (14, 17, "USA apertura"), (17, 22, "USA pomeriggio"), (22, 24, "rollover")]  # come leggi_gba_r0.py r.52
RX = re.compile(r"segnale (BUY|SELL)( SALTATO)?.*?ATR ([\d.]+) spread ([\d.]+) =.*?stop/spread (-?[\d.]+)x \| ora server (\d+)")

def carica(zp, nome):
    righe = []
    for l in zipfile.ZipFile(zp).read(nome).decode("utf-8", "replace").splitlines():
        m = RX.search(l)
        if m:
            righe.append((m.group(1), bool(m.group(2)), float(m.group(3)), float(m.group(4)), float(m.group(5)), int(m.group(6))))
    return righe

def val(x):  # -1.0x = spread zero = costo nullo = rapporto infinito
    return x[4] if x[4] >= 0 else 1e9

def med(L):
    return round(S.median([val(x) for x in L]), 2) if L else None

def rapporto(zp, nome, tit):
    r = carica(zp, nome)
    print("== %s: %d righe, %d SALTATO, %d ingressi, %d a spread zero" % (tit, len(r), sum(x[1] for x in r), sum(1 for x in r if not x[1]), sum(1 for x in r if x[4] < 0)))
    print("   C3G cella %s | BUY %s | SELL %s | ATR mediana %s | spread mediano %s | righe >=50x: %d"
          % (med(r), med([x for x in r if x[0] == "BUY"]), med([x for x in r if x[0] == "SELL"]), S.median([x[2] for x in r]), S.median([x[3] for x in r]), sum(1 for x in r if val(x) >= 50)))
    for lo, hi, n in FASCE:
        s = [x for x in r if lo <= x[5] < hi]
        print("   %-15s righe %4d C3G %6s | BUY %6s (%d) SELL %6s (%d) | spread %.2f | >=50x: %3d | ingressi: %3d"
              % (n, len(s), med(s), med([x for x in s if x[0] == "BUY"]), sum(1 for x in s if x[0] == "BUY"), med([x for x in s if x[0] == "SELL"]),
                 sum(1 for x in s if x[0] == "SELL"), S.median([x[3] for x in s]), sum(1 for x in s if val(x) >= 50), sum(1 for x in s if not x[1])))

if __name__ == "__main__":
    for t in (S0, R1A):
        rapporto(*t)
