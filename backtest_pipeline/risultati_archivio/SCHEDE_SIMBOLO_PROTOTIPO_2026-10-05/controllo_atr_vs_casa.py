#!/usr/bin/env python3
# -*- coding: ascii -*-
# CONTROLLO DEL PROTOTIPO scheda_simbolo.py CONTRO NUMERI GIA' SCRITTI DA UN ALTRO PERCORSO DI CODICE.
# I valori di riferimento sono quelli stampati dai referti di ema200_d1_su_m5.py (01/10/2026):
#   backtest_pipeline/risultati_archivio/EMA200_D1_M5_2026-10-02/REFERTO_<D30EUR|SPXUSD|XAUUSD_B>_UTC1.txt
#   riga "ATR mediano (dal giorno 600): M5 .. M15 .. H1 .."
# Cosa prova: lettura dei file, conversione NY->UTC, orologio server UTC+1, giorni, barre per TF, ATR(14).
# Cosa NON prova: l'indipendenza della FORMULA dell'ATR (qui e' la stessa convenzione della casa, copiata di proposito).
# Uso: python3 controllo_atr_vs_casa.py <cartella GRXEUR> <cartella SPXUSD> <cartella zip oro HistData>
import sys, os
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import scheda_simbolo as S
if len(sys.argv) != 4:
    sys.exit("uso: controllo_atr_vs_casa.py DIR_GRXEUR DIR_SPXUSD DIR_ORO_ZIP")
casi = [("D30EUR", sys.argv[1], {"M5": 9.2679, "M15": 17.0000, "H1": 35.4286}),
        ("SPXUSD", sys.argv[2], {"M5": 0.8750, "M15": 1.5893, "H1": 3.4643}),
        ("XAUUSD", sys.argv[3], {"M5": 2.0761, "M15": 3.7575, "H1": 7.6206})]
ok_tutti = True
for sim, perc, rif in casi:
    s = S.carica_serie(sim, "x", "NY", perc)
    S.costruisci(s)
    print("%s: M1 %d, giorni %d" % (sim, len(s["t"]), len(s["d1"]["st"])))
    for nome, tfm in (("M5", 5), ("M15", 15), ("H1", 60)):
        b = S.barre_tf(s, tfm)
        a = S.atr_sma(b["o"], b["h"], b["l"], b["c"], 14)
        ok = np.isfinite(a) & (b["day"] >= 600)
        mio = float(np.median(a[ok]))
        scarto = 100.0 * (mio / rif[nome] - 1.0)
        print("   %s: mio %.4f   casa %.4f   scarto %+.3f%%" % (nome, mio, rif[nome], scarto))
        ok_tutti &= abs(scarto) < 0.05
print("ESITO: %s" % ("COINCIDONO (scarto < 0,05%)" if ok_tutti else "DIFFERISCONO"))
sys.exit(0 if ok_tutti else 2)
