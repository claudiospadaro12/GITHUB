#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_round_corti_c.py -- LA LETTURA del ROUND CORTI C (R264 + R265 + R266 +
R260d + R267) dalla raccolta ROUND_CORTI_C_<data>.zip estratta, prodotta sul
PC di backtest dalla riga backtest_pipeline/righe/RIGA_ROUND_CORTI_C_R264_R267.txt
(PASS e8e2fdb8, 37 job, pin 0482fd80). La riga fa la PRE-LETTURA; questo
script RIFA' i cancelli in modo indipendente (due strati, il primo che
fallisce blocca) e applica i CRITERI CONGELATI PRIMA DEI NUMERI:
  R264  prove/R264_TESTA.txt.in (= testa di R264a_controllo) par. 5 (G0, C0
        classe 844, K1 classe 846), 6.3 (G2), 7 (attesa H_FETTA/H_MOTORE),
        8 (S0-S8: D0, S1 >= 276 deal, S2 centro = MEZZO mai il picco, S3, S4,
        S5, S6, S7, S8), 9 (ponte AUDJPY: CONFERMA/SMENTITA/NON CONCLUDENTE)
  R265  prove/R265_TESTA.txt.in par. 2 (K1 26,54 pip, PASS/FAIL/NON RISOLTO),
        3 (bande G0), 4 (griglia a una dimensione, H_DERIVA/H_EDGE)
  R266  prove/R266a_asia_box_GBPUSD_TESTA.txt par. 5 (K1 per costruzione),
        6.2 (bande n, struttura n_long+n_short >= n_due_lati), 6.3 (HN/HE/H0),
        7 (D0, D1, G1, L0, C0, K1, R2, R3, R4), 8 (finestra e regimi)
  R260d prove/R260d_oro_770402_solo_long_trend_oro.txt par. 3-4 (T3, S0, T5,
        partizione HN/HQ/H0/HG/HR, rischio a 0,5 contro 2,00/2,06)
  R267  prove/R267a_news_oro_770402.txt par. 0 (regola comune, classe 850) e
        prove/R267_GENERA.py: B1-B6 (R267b), C1-C6 (R267c), V1-V5 (R267d),
        E1-E5 (R267e/f), U1-U6 (R267g2/g3/g4), D1-D6 (R267g1). R267a e'
        ESCLUSO E DICHIARATO (par. 6-A aperto): la sua assenza e' ATTESA.
Regole di casa applicate (con la fonte accanto): Emendamento della finestra
(CLAUDE.md: IS in operazioni, regime DICHIARATO, il vecchio giudica il
rischio e il recente il merito), certificato di morte a 5 caselle (09/09),
classe 804 (verdetto asimmetrico sul rischio), classi 844/846/850/855,
altopiano al CENTRO mai il picco (3 celle contigue), M1-M3 contro il
CONTROLLO dello stesso round (modello leggi_r255.py), R4/B6/C6/V5/U6/D6/E4:
NESSUNA cella si promuove, NESSUNA PROPOSTA DI TAGLIA.

SOLA LETTURA: non tocca EA, preset, prove, CSV, sedie, conti, taglie.
Scrive SOLO il file passato con --md (default: stdout).
Etichette: [MISURATO] dal CSV o dal per-trade della raccolta; [DERIVATO] da
una formula scritta nella testa; [STIMA]; [NON MISURATO]; [NON VERIFICABILE].

Uso:
  python3 backtest_pipeline/leggi_round_corti_c.py RACCOLTA_DIR [--md OUT.md] [--archivi DIR]
  python3 backtest_pipeline/leggi_round_corti_c.py --autotest [--fixture-dir DIR]
RACCOLTA_DIR = la cartella ROUND_CORTI_C_<data> estratta dallo zip:
  ROUND_<t>/REFERTO_ROUND_<t>.txt, ROUND_<t>/<EA>_<sim>_IS<_ohlc>_<t>.csv,
  ROUND_<t>/<EA>_<sim>_OOS<_ohlc>_<t>.csv, ROUND_<t>/<file prova>,
  PERTRADE/abtg_trades_<EA>_<sim>_<magic>.csv, ESTERNI/ (CSV e per-trade di
  R260a/R260c/R261a/R255a se erano sul PC), LOG_TESTER/*.log (UTF-16),
  RIEPILOGO_ROUND_CORTI_C.txt.
Gli ESTERNI mancanti si cercano in --archivi e poi in
risultati_archivio/ROUND_CORTI_B_2026-09-27 (R260a/R260c/R261a); R255a non e'
in repo: senza, le letture che ne dipendono restano NON VERIFICABILI.
"""
import argparse
import csv
import math
import os
import re
import statistics
import sys
import tempfile
from bisect import bisect_left
from collections import OrderedDict, defaultdict
from datetime import datetime, timedelta

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import autopsia_pertrade as ap  # noqa: E402  (riuso: leggi_deal, aggrega, pf, tabella)
try:
    from r253_referto import valore_punto as _valore_punto  # noqa: E402  (riuso dichiarato, descrittivo)
except Exception:  # pragma: no cover
    _valore_punto = None

EPS = 1e-6
ARCHIVI_REPO = os.path.join(QUI, "risultati_archivio", "ROUND_CORTI_B_2026-09-27")
PROVE_REPO = os.path.join(QUI, "prove")
N_MERITO = 150            # posizioni (Emendamento A, criterio di casa)
DEAL_MERITO = 276         # R264 par. 8 S1: 150 pos x 1,838 deal/pos
MURO_1PCT = 10.0          # S3 di R264 par. 8: DD a rischio 1% contro il muro 10%
S3_R193B = 8.0            # S3 di R193b a 2,00%: 8,0% (R260c par. 8, R266 par. 7 R3)
FATT_2PCT = (1.956, 1.990)  # R264 par. 8 S3: derivato a 2,00% da 1%
R2_DOW = 4.272            # tetto R2 di R255a par. 9 (saldo chiuso, per la cella identificata)
PEGG_DOW = -1.10          # R3 di R255a (peggior giornata %, informativo qui)

# ---------------------------------------------------------------------------
#  I 37 JOB DELLA RIGA (copiati dalla riga C: t, EA, simbolo, prova, modello, deposito,
#  suffisso, gambe attese (IS/OOS/IO), gamba principale, righe attese, asse, valori,
#  gemelle, magic fisso, cella attesa del per-trade, lato (sd), gruppo, regola del k,
#  pin numerici attesi, finestra del per-trade d0->d1, finestra IS da->dm)
# ---------------------------------------------------------------------------
def _j(t, e, s, p, m, dp, sm, lg, pl, nr, ax, av, pt, pid, pav, sd, grp, kr, np_, d0, d1, da, dm):
    return dict(t=t, e=e, s=s, p=p, m=m, dp=dp, sm=sm, lg=lg, pl=pl, nr=nr, ax=ax, av=av, pt=pt, pid=pid,
                pav=pav, sd=sd, grp=grp, kr=kr, np=np_, d0=d0, d1=d1, da=da, dm=dm)


EMA, MMN, DOW = "ABTG_EMA200", "ABTG_MaxMinNotte", "ABTG_Dow_Apertura_US"
JOBS = OrderedDict((j["t"], j) for j in [
    _j("R264c", EMA, "GBPJPY", "R264c_controllo_EMA200_GBPJPY.txt", 4, 10000, "", "OOS", "OOS", 2, "InpMagic", [796521, 796571], ["796521", "796571"], "", "", "", "R264G0", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R264d", EMA, "XAUUSD", "R264d_controllo_EMA200_XAUUSD.txt", 4, 10000, "", "OOS", "OOS", 2, "InpMagic", [796531, 796581], ["796531", "796581"], "", "", "", "R264G0", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R264a", EMA, "GBPUSD", "R264a_controllo_EMA200_GBPUSD.txt", 4, 10000, "", "OOS", "OOS", 2, "InpMagic", [796501, 796551], ["796501", "796551"], "", "", "", "R264G0", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R264b", EMA, "AUDJPY", "R264b_controllo_EMA200_AUDJPY.txt", 4, 10000, "", "OOS", "OOS", 2, "InpMagic", [796511, 796561], ["796511", "796561"], "", "", "", "R264G0", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R264b1", EMA, "AUDJPY", "R264b1_ponte_R139a_EMA200_AUDJPY.txt", 1, 10000, "_ohlc", "OOS", "OOS", 4, "InpTP_RR", [1.5, 2, 2.5, 3], [], "796512", "3", "", "R264P", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R265a", EMA, "EURUSD", "R265a_atr_controllo_EMA200_EURUSD_short.txt", 1, 10000, "_ohlc", "OOS", "OOS", 2, "InpMagic", [798501, 798551], ["798501", "798551"], "", "", "", "R265G0", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R264c1", EMA, "GBPJPY", "R264c1_o2_050_EMA200_GBPJPY.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796522", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2019.01.01", "2023.12.31"),
    _j("R264c2", EMA, "GBPJPY", "R264c2_o2_060_EMA200_GBPJPY.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796523", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2019.01.01", "2023.12.31"),
    _j("R264c3", EMA, "GBPJPY", "R264c3_o2_070_EMA200_GBPJPY.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796524", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2019.01.01", "2023.12.31"),
    _j("R264c4", EMA, "GBPJPY", "R264c4_uscita_EMA200_GBPJPY.txt", 1, 100000, "_ohlc", "IO", "OOS", 4, "InpTP1Pct", [0, 25, 50, 75], [], "796525", "75", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2019.01.01", "2023.12.31"),
    _j("R264d1", EMA, "XAUUSD", "R264d1_o2_050_EMA200_XAUUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796532", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2017.01.01", "2023.12.31"),
    _j("R264d2", EMA, "XAUUSD", "R264d2_o2_060_EMA200_XAUUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796533", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2017.01.01", "2023.12.31"),
    _j("R264d3", EMA, "XAUUSD", "R264d3_o2_070_EMA200_XAUUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796534", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2017.01.01", "2023.12.31"),
    _j("R264d4", EMA, "XAUUSD", "R264d4_uscita_EMA200_XAUUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 4, "InpTP1Pct", [0, 25, 50, 75], [], "796535", "75", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2017.01.01", "2023.12.31"),
    _j("R264a1", EMA, "GBPUSD", "R264a1_o2_030_EMA200_GBPUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796502", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2020.01.01", "2023.12.31"),
    _j("R264a2", EMA, "GBPUSD", "R264a2_o2_040_EMA200_GBPUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796503", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2020.01.01", "2023.12.31"),
    _j("R264a3", EMA, "GBPUSD", "R264a3_o2_050_EMA200_GBPUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 3, "InpOrder1Atr", [0.1, 0.2, 0.3], [], "796504", "0.3", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2020.01.01", "2023.12.31"),
    _j("R264a4", EMA, "GBPUSD", "R264a4_uscita_EMA200_GBPUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 4, "InpTP1Pct", [0, 25, 50, 75], [], "796505", "75", "", "R264W", "fx", 40, "2024.01.01", "2026.06.30", "2020.01.01", "2023.12.31"),
    _j("R265b", EMA, "EURUSD", "R265b_short_o2_EMA200_EURUSD.txt", 1, 100000, "_ohlc", "IO", "OOS", 4, "InpOrder2Atr", [0.1, 0.2, 0.3, 0.4], [], "798502", "0.4", "", "R265W", "fx", 40, "2024.01.01", "2026.06.30", "2017.01.01", "2023.12.31"),
    _j("R266a", MMN, "GBPUSD", "R266a_asia_box_GBPUSD_TESTA.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796601, 796651], ["796601", "796651"], "", "", "", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R266b", MMN, "GBPUSD", "R266b_asia_box_GBPUSD_solo_long.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796602, 796652], ["796602", "796652"], "", "", "1", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R266c", MMN, "GBPUSD", "R266c_asia_box_GBPUSD_solo_short.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796603, 796653], ["796603", "796653"], "", "", "0", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R266d", MMN, "EURUSD", "R266d_asia_box_EURUSD_due_lati.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796604, 796654], ["796604", "796654"], "", "", "", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R266e", MMN, "EURUSD", "R266e_asia_box_EURUSD_solo_long.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796605, 796655], ["796605", "796655"], "", "", "1", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R266f", MMN, "EURUSD", "R266f_asia_box_EURUSD_solo_short.txt", 1, 10000, "_ohlc", "IO", "OOS", 2, "InpMagic", [796606, 796656], ["796606", "796656"], "", "", "0", "R266", "fx", 48, "2020.01.01", "2026.06.30", "2015.01.01", "2019.12.31"),
    _j("R260d", MMN, "XAUUSD", "R260d_oro_770402_solo_long_trend_oro.txt", 1, 100000, "_ohlc", "OOS", "OOS", 2, "InpMagic", [795304, 795354], ["795304", "795354"], "", "", "1", "R260", "oro260", 48, "2020.01.01", "2026.06.30", "2019.12.30", "2019.12.31"),
    _j("R267b", MMN, "XAUUSD", "R267b_minbox_oro_770402.txt", 1, 100000, "_ohlc", "OOS", "OOS", 5, "InpMinBoxPts", [0, 650, 1300, 1950, 2600], [], "796702", "2600", "", "R267", "fx", 48, "2020.01.01", "2026.06.30", "2019.12.30", "2019.12.31"),
    _j("R267d", DOW, "U30USD", "R267d_short_DOW_volumi_1430.txt", 4, 10000, "", "OOS", "OOS", 5, "InpVolMult", [0, 0.5, 1, 1.5, 2], [], "796712", "2", "0", "R267", "usd", 77, "2024.09.27", "2026.06.30", "2024.09.26", "2024.09.26"),
    _j("R267c", DOW, "U30USD", "R267c_short_DOW_uscita90_1430.txt", 4, 10000, "", "OOS", "OOS", 2, "InpCloseHour", [16, 17], [], "796711", "17", "0", "R267", "usd", 77, "2024.09.27", "2026.06.30", "2024.09.26", "2024.09.26"),
    _j("R267g2", MMN, "D30EUR", "R267g2_dax_long_trailing.txt", 4, 100000, "", "IS", "IS", 2, "InpUseTrailing", [0, 1], [], "796742", "1", "1", "R267", "dax", 48, "2024.09.26", "2026.06.30", "2024.09.26", "2026.06.30"),
    _j("R267g3", MMN, "D30EUR", "R267g3_dax_long_breakeven.txt", 4, 100000, "", "IS", "IS", 2, "InpBreakeven", [0, 1], [], "796743", "1", "1", "R267", "dax", 48, "2024.09.26", "2026.06.30", "2024.09.26", "2026.06.30"),
    _j("R267g4", MMN, "D30EUR", "R267g4_dax_long_parziale.txt", 4, 100000, "", "IS", "IS", 4, "InpTP1Pct", [0, 25, 50, 75], [], "796744", "75", "1", "R267", "dax", 48, "2024.09.26", "2026.06.30", "2024.09.26", "2026.06.30"),
    _j("R267g1", MMN, "D30EUR", "R267g1_dax_long_trend_DAX.txt", 4, 100000, "", "IS", "IS", 5, "InpCorrTF", [16388, 16390, 16392, 16396, 16408], [], "796741", "16408", "1", "R267", "dax", 48, "2024.09.26", "2026.06.30", "2024.09.26", "2026.06.30"),
    _j("R267e1", EMA, "GBPJPY", "R267e1_adr_EMA200_GBPJPY.txt", 4, 10000, "", "OOS", "OOS", 2, "InpUseAdrFilter", [0, 1], [], "796721", "1", "", "R267", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R267f1", EMA, "GBPJPY", "R267f1_venerdi_EMA200_GBPJPY.txt", 4, 10000, "", "OOS", "OOS", 2, "InpFridayClose", [0, 1], [], "796731", "1", "", "R267", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R267e2", EMA, "XAUUSD", "R267e2_adr_EMA200_XAUUSD.txt", 4, 10000, "", "OOS", "OOS", 2, "InpUseAdrFilter", [0, 1], [], "796722", "1", "", "R267", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
    _j("R267f2", EMA, "XAUUSD", "R267f2_venerdi_EMA200_XAUUSD.txt", 4, 10000, "", "OOS", "OOS", 2, "InpFridayClose", [0, 1], [], "796732", "1", "", "R267", "fx", 40, "2024.01.01", "2026.06.30", "2023.12.31", "2023.12.31"),
])
assert len(JOBS) == 37
R267A = dict(t="R267a", e=MMN, s="XAUUSD", p="R267a_news_oro_770402.txt")   # ESCLUSO E DICHIARATO (par. 6-A aperto)

# ancore G0 (R264 par. 1a / 12, R265 par. 1b): n, PF, DD, Profit, nome
ANC_G0 = {
    "R264a": dict(tr=362, pf=1.23105, dd=7.2048, pr=728.66, nome="Pass 139 O1 0.25 / O2 0.2 / TP 2.0"),
    "R264b": dict(tr=265, pf=1.51365, dd=6.2606, pr=1181.78, nome="Pass 411 O1 0.05 / O2 0.4 / TP 3.0"),
    "R264c": dict(tr=221, pf=1.24037, dd=4.4220, pr=609.52, nome="Pass 55 O1 0.10 / O2 0.4 / TP 1.5"),
    "R264d": dict(tr=187, pf=1.38074, dd=6.1446, pr=991.09, nome="Pass 311 O1 0.30 / O2 0.4 / TP 2.5"),
    "R265a": dict(tr=180, pf=1.32379, dd=4.3273, pr=441.21, nome="Pass 94 O1 0.30 / O2 0.5 / TP 1.5 solo corto"),
}
ANC_PONTE = {1.5: "tick d'archivio PF 1.71095 n 276 DD 2.8888", 2.0: "tick d'archivio PF 1.62295 n 283 DD 2.9009",
             2.5: "NON visitata dal genetico", 3.0: "tick d'archivio PF 1.64064 n 286 DD 2.9174"}
G0_ORO = dict(tr=693, pf=1.308, pr=24736, dd=5.32)     # R103 (R260c par. 7 R1, R267b B1)
# K1 (R264 par. 5, R265 par. 2): C, q (EUR per unita' di quota; 'P' = 1/price), rischio per gamba,
# rapporto vol2/vol1 atteso e banda, soglia in unita' di quota, unita', scala di stampa, decisione
K1PAR = {
    "R264a": dict(cs=100000, q=0.86287, rf=0.005, rat=1.45, rlo=1.16, rhi=1.8125, sog=0.00337, un="pip", sc=10000,
                  dec="GBPUSD: 33,7 pip = 40 x 0,8425 (logger 0,300 + comm. 0,5425); col metro della sonda 29,7 pip"),
    "R264b": dict(cs=100000, q=0.0054147, rf=0.005, rat=1.45, rlo=1.16, rhi=1.8125, sog=0, un="pip", sc=100,
                  dec="AUDJPY: spread e commissione NON MISURATI: SOLO LETTURA dello stop, nessun verdetto"),
    "R264c": dict(cs=100000, q=0.0054147, rf=0.005, rat=1.5, rlo=1.2, rhi=1.875, sog=0, un="pip", sc=100,
                  dec="GBPJPY: comm. 0,8645 pip + spread NON MISURATO -> soglia >= 34,6 pip + 40 x spread: K1 NON DECIDIBILE finche' lo spread non c'e'"),
    "R264d": dict(cs=100, q=0.86287, rf=0.005, rat=1.7, rlo=1.36, rhi=2.125, sog=10.41, un="USD", sc=1,
                  dec="XAUUSD: 10,41 $ = 40 x 0,2603 (logger 0,220 + comm. 0,0403); di casa alle 08/14: 10,01 $"),
    "R265a": dict(cs=100000, q="P", rf=0.005, rat=1.8, rlo=1.5, rhi=2.2, sog=0.002654, un="pip", sc=10000,
                  dec="EURUSD: 26,54 pip = 40 x 0,6636 (logger 0,200 + comm. 0,4636); al P95 38,54; col metro della sonda 34,56"),
}
K1_R266 = {"GBPUSD": 0.00337, "EURUSD": 0.00266}    # R266 par. 5 (277 / 206 punti + 2 x 30 di buffer)
BAND266 = {"R266a": (529, 1129, 687, 1467), "R266b": (268, 573, 349, 745), "R266c": (317, 677, 412, 879),
           "R266d": (378, 1129, 491, 1467), "R266e": (192, 573, 249, 745), "R266f": (226, 677, 294, 879)}
# ESTERNI: G0 di altre righe (letti se presenti, MAI rilanciati)
EXT = OrderedDict([
    ("R260a", dict(e=MMN, s="XAUUSD", lg="OOS", sm="_ohlc", mg="795301", d0="2020.01.01", d1="2026.06.30", kr="oro260", nr=2, ax="InpMagic")),
    ("R260c", dict(e=MMN, s="XAUUSD", lg="OOS", sm="_ohlc", mg="795303", d0="2020.01.01", d1="2026.06.30", kr="oro260", nr=2, ax="InpMagic")),
    ("R261a", dict(e=MMN, s="D30EUR", lg="IS", sm="", mg="795401", d0="2024.09.26", d1="2026.06.30", kr="dax", nr=2, ax="InpUseCorrelation")),
    ("R255a", dict(e=DOW, s="U30USD", lg="OOS", sm="", mg="793101", d0="2024.09.27", d1="2026.06.30", kr="usd", nr=2, ax="InpMagic")),
])
GRID = OrderedDict([
    ("c", dict(sym="GBPJPY", f=["R264c1", "R264c2", "R264c3"], x4="R264c4", o2=[0.5, 0.6, 0.7], prx=[0.5], g0="R264c", yis=5.0,
               regime="IS 2019-2023: fine ciclo pre-Covid, crollo Covid 2020, inflazione e rialzi 2022-2023 (yen debole)")),
    ("d", dict(sym="XAUUSD", f=["R264d1", "R264d2", "R264d3"], x4="R264d4", o2=[0.5, 0.6, 0.7], prx=[0.5], g0="R264d", yis=7.0,
               regime="IS 2017-2023: laterale 2017-2018, toro 2019-2020, laterale 2021-2022, toro 2023")),
    ("a", dict(sym="GBPUSD", f=["R264a1", "R264a2", "R264a3"], x4="R264a4", o2=[0.3, 0.4, 0.5], prx=[0.3, 0.4], g0="R264a", yis=4.0,
               regime="IS 2020-2023: crollo Covid, dollaro debole 2020-2021, rialzi Fed e mini-budget 2022, laterale 2023")),
])
REGIMI = {
    "R265b": "IS 2017-2023 (R265 par. 4): euro in salita 2017/2020, in discesa 2018/2021-2022, 2023 laterale-rialzista -> bilanciato per H_DERIVA; OOS 2024-2026 = la finestra della scansione (NON cieca a livello di vicinato, R264 par. 4)",
    "R266": "IS 2015-2019 (R266 par. 8): QE BCE e dollaro forte, shock Brexit 2016, compressione 2017-2019 = SHOCK + LATERALE/COMPRESSO (gli anni della sonda); OOS 2020-2026: crollo Covid, trend del dollaro e rialzi 2021-2022, laterale 2023-2024, dollaro debole 2025 = CROLLO + TREND + LATERALE",
    "R264OOS": "OOS 2024.01-2026.06 = la finestra del genetico: conferma DEBOLE (R264 par. 4), NON cieca a livello di vicinato",
    "R260": "2020.01-2026.06 (R260c par. 5): toro 2020, laterale 2021-2022, toro 2023-2026; meta' esatta al 2023.04.01",
    "R267dow": "2024.09.27-2026.06.30 (R255a): ~21 mesi, UN solo regime, orologio BCM UTC+1 fisso (due ere IS/OOS di R255 al 2025.06.10)",
    "R267dax": "2024.09.26-2026.06.30 (R261a): tranche unica, ~21 mesi, riscaldamento EMA100 (classe 834) sulle celle alte",
}


# ---------------------------------------------------------------------------
#  Utilita' di formato e lettura
# ---------------------------------------------------------------------------
def f2(x):
    return "n.d." if x is None or (isinstance(x, float) and math.isnan(x)) else "%.2f" % x


def f3(x):
    return "n.d." if x is None or (isinstance(x, float) and math.isnan(x)) else "%.3f" % x


def fpf(x):
    if x is None or (isinstance(x, float) and math.isnan(x)):
        return "n.d."
    return "inf" if x == float("inf") else "%.3f" % x


def num(s):
    s = ("" if s is None else str(s)).strip()
    if s.lower() == "true":
        return 1.0
    if s.lower() == "false":
        return 0.0
    try:
        return float(s.replace(",", "."))
    except ValueError:
        return float("nan")


def ct(d):
    return d["t"].strftime("%Y.%m.%d %H:%M:%S")


def dstr(t):
    return t.strftime("%Y.%m.%d")


def leggi_pertrade(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        deals = ap.leggi_deal(fh)
    deals.sort(key=lambda d: (d["t"], d["pid"]))
    return deals


def leggi_csv(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        return [r for r in csv.DictReader(fh) if any((v or "").strip() for v in r.values())]


def leggi_testo(path):
    """testo di un file della raccolta: UTF-16 se ha il BOM o NUL nei primi byte (log di MT5), altrimenti UTF-8."""
    raw = open(path, "rb").read()
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff") or b"\x00" in raw[:4000]:
        return raw.decode("utf-16", errors="replace")
    return raw.decode("utf-8", errors="replace")


def cella(rows, asse, val):
    hit = [r for r in rows if abs(num(r.get(asse)) - float(val)) <= EPS]
    return hit[0] if len(hit) == 1 else None


def riga_txt(r, pegg=False):
    if r is None:
        return "riga MANCANTE"
    s = "Trades %s, Profit %s, PF %s, Equity DD %% %s" % (r.get("Trades"), r.get("Profit"), r.get("Profit Factor"), r.get("Equity DD %"))
    if pegg:
        s += ", Peggior Giornata %% %s" % r.get("Peggior Giornata %")
    return s


def cmp4(ra, rb, pegg=False):
    """le differenze fra due righe di CSV sui campi che decidono (epsilon 0,000001)."""
    if ra is None or rb is None:
        return ["riga MANCANTE"]
    dif = []
    cols = ["Trades", "Profit", "Profit Factor", "Equity DD %"] + (["Peggior Giornata %"] if pegg else [])
    for cn in cols:
        if not (abs(num(ra.get(cn)) - num(rb.get(cn))) <= EPS):
            dif.append("%s %s contro %s" % (cn, ra.get(cn), rb.get(cn)))
    return dif


def n_pos(deals):
    return len(set(d["pid"] for d in deals))


def leggi_pin_prova(path):
    """pin numerici/bool (||N), asse (||Y), stringhe (senza ||) del file prova."""
    pin, asse, stringhe = OrderedDict(), [], []
    with open(path, encoding="utf-8", errors="replace") as fh:
        for ln in fh:
            ln = ln.strip()
            m = re.match(r"^(Inp[A-Za-z0-9_]+)=(.*)$", ln)
            if not m:
                continue
            nome, rest = m.group(1), m.group(2).strip()
            m2 = re.match(r"^([^|]*)\|\|([^|]*)\|\|([^|]*)\|\|([^|]*)\|\|([YN])\s*$", rest)
            if m2:
                if m2.group(5) == "Y":
                    asse.append(nome)
                else:
                    v = num(m2.group(1))
                    if math.isnan(v):
                        stringhe.append(nome)
                    else:
                        pin[nome] = v
            else:
                stringhe.append(nome)
    return pin, asse, stringhe


# ---------------------------------------------------------------------------
#  Le formule di casa (ognuna con un contro-esempio nell'autotest)
# ---------------------------------------------------------------------------
def k_rule(kr, somma, profit, lotti, n_righe, trades):
    """C0 per simbolo (riga C, classe 844/855): ritorna (ok, somma-Profit, k)."""
    dC = somma - profit
    k = dC / lotti if lotti > 0 else float("nan")
    if not math.isnan(k) and abs(k) < 5e-5:
        k = 0.0
    ok = False
    if n_righe == trades and n_righe > 0:
        if kr == "usd":
            ok = abs(dC) <= 0.05
        elif kr == "dax":
            ok = abs(dC) <= 0.05 or (not math.isnan(k) and 1.0 <= k <= 3.0)
        elif kr == "oro260":
            ok = dC >= -0.05 and not math.isnan(k) and k <= 3.0
        else:
            ok = not math.isnan(k) and 1.0 <= k <= 3.0
    return ok, dC, k


def k_txt(kr):
    return {"usd": "U30USD: somma = Profit entro 0,05 (commissione 0,000)",
            "dax": "D30EUR: somma = Profit entro 0,05 oppure k in [1,00 ; 3,00] (commissione NON MISURATA)",
            "oro260": "XAUUSD famiglia R260: somma - Profit >= -0,05 e k <= 3,00 EUR/lotto (classe 844)"}.get(
        kr, "forex/oro: k = (somma - Profit) / lotti in [1,00 ; 3,00] EUR/lotto (classe 844)")


class SaldoPrima:
    """saldo (con k) PRIMA di un istante: dep + somma (net - k x vol) dei deal chiusi prima."""

    def __init__(self, deals, k, dep):
        ds = sorted(deals, key=lambda x: (x["t"], x["pid"]))
        self.ts = [d["t"] for d in ds]
        self.cum, s = [], dep
        for d in ds:
            s += d["net"] - k * d["vol"]
            self.cum.append(s)
        self.dep = dep

    def prima(self, t):
        i = bisect_left(self.ts, t)
        return self.cum[i - 1] if i > 0 else self.dep


def posizioni(deals, k, dep):
    """una riga per position_id: vol, net (senza k), t0/t1, prezzo del primo deal, saldo PRIMA (con k)."""
    by = OrderedDict()
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        by.setdefault(d["pid"], []).append(d)
    sp = SaldoPrima(deals, k if not math.isnan(k) else 0.0, dep)
    out = []
    for pid, ds in by.items():
        out.append(dict(pid=pid, vol=sum(x["vol"] for x in ds), net=sum(x["net"] for x in ds), t0=ds[0]["t"], t1=ds[-1]["t"],
                        px=ds[0]["price"], nd=len(ds), deals=ds, saldo=sp.prima(ds[0]["t"]), day=ds[-1]["t"].date()))
    out.sort(key=lambda p: (p["t0"], p["pid"]))
    return out


def pf_win(deals, dlo, dhi, k):
    """PF in POSIZIONI (net - k x vol) per data di CHIUSURA (ultimo deal) in [dlo ; dhi] ('' = senza limite)."""
    kk = 0.0 if (k is None or math.isnan(k)) else k
    agg, last = defaultdict(float), {}
    for d in deals:
        agg[d["pid"]] += d["net"] - kk * d["vol"]
        last[d["pid"]] = max(last.get(d["pid"], d["t"]), d["t"])
    gp = gl = 0.0
    n = 0
    for pid, v in agg.items():
        ds_ = dstr(last[pid])
        if (dlo and ds_ < dlo) or (dhi and ds_ > dhi):
            continue
        n += 1
        if v > 0:
            gp += v
        else:
            gl -= v
    return dict(n=n, pf=(gp / gl if gl > 0 else (float("inf") if gp > 0 else 0.0)), gp=gp, gl=gl, net=gp - gl, ep=((gp - gl) / n if n else 0.0))


def curva_saldo(deals, k, dep):
    out, s = [], dep
    kk = 0.0 if (k is None or math.isnan(k)) else k
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        s += d["net"] - kk * d["vol"]
        out.append((d["t"], s))
    return out


def dd_chiuso(curva, dep):
    """DD massimo a saldo chiuso in % del picco (classe 550), con date di picco e fondo."""
    pk, dpk, ddm, eur, d_pk, d_fo = dep, None, 0.0, 0.0, None, None
    for t, s in curva:
        if s > pk:
            pk, dpk = s, t
        dd = 100.0 * (pk - s) / pk
        if dd > ddm:
            ddm, eur, d_pk, d_fo = dd, pk - s, dpk, t
    return dict(dd=ddm, eur=eur, pk=d_pk, fo=d_fo, fin=(curva[-1][1] if curva else dep))


def peggior_giornata(deals, k, dep):
    """peggior giornata a saldo chiuso, denominatore = SALDO A INIZIO GIORNATA (R255a par. 9, leggi_r255.curva)."""
    kk = 0.0 if (k is None or math.isnan(k)) else k
    s = dep
    start, pnl = OrderedDict(), OrderedDict()
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        g = d["t"].date()
        if g not in start:
            start[g] = s
        v = d["net"] - kk * d["vol"]
        pnl[g] = pnl.get(g, 0.0) + v
        s += v
    pegg, data = 0.0, None
    for g, v in pnl.items():
        p = 100.0 * v / start[g]
        if p < pegg:
            pegg, data = p, g
    return dict(pct=pegg, data=data, eur=(pnl.get(data, 0.0) if data else 0.0))


def dd_taglia(d, f, base):
    """[DERIVATO] DD a taglia f da un DD d misurato a taglia base (R193b B3 / R260c par. 8):
    pavimento moltiplicativo 1-(1-d)^(f/base), tetto lineare (f/base) x d; d e f in %."""
    e = f / base
    return 100.0 * (1.0 - (1.0 - d / 100.0) ** e), e * d


def k1_lotto(pos, prm):
    """K1 dal LOTTO (R264 par. 5 / R265 par. 2, classe 846): coppie gamba1/gamba2 = position_id e position_id+1;
    stop di gamba 2 in [R/((vol+0,01) C q) ; R/(vol C q)], R = saldo prima x rf. Contro-esempio interno:
    vol2/vol1 in [rlo ; rhi] e ATR da gamba 1 (s1/rat) e da gamba 2 entro +-12%, altrimenti K1 NULLO."""
    by = {p["pid"]: p for p in pos}
    used, lows, highs, rats, s1s = set(), [], [], [], []
    n_pair = n_sing = rat_ko = atr_ko = v1ge02 = 0
    for pid in sorted(by):
        if pid in used:
            continue
        if (pid + 1) in by and (pid + 1) not in used:
            p1, p2 = by[pid], by[pid + 1]
            used.update((pid, pid + 1))
            n_pair += 1
            if p1["vol"] >= 0.02:
                v1ge02 += 1
            q = (1.0 / p2["px"] if p2["px"] > 0 else 0.0) if prm["q"] == "P" else float(prm["q"])
            if q > 0 and p1["vol"] > 0 and p2["vol"] > 0:
                rr1, rr2 = p1["saldo"] * prm["rf"], p2["saldo"] * prm["rf"]
                lo2, hi2 = rr2 / ((p2["vol"] + 0.01) * prm["cs"] * q), rr2 / (p2["vol"] * prm["cs"] * q)
                lo1, hi1 = rr1 / ((p1["vol"] + 0.01) * prm["cs"] * q), rr1 / (p1["vol"] * prm["cs"] * q)
                lows.append(lo2)
                highs.append(hi2)
                rt = p2["vol"] / p1["vol"]
                rats.append(rt)
                s1m, s2m = (lo1 + hi1) / 2.0, (lo2 + hi2) / 2.0
                s1s.append(s1m)
                if rt < prm["rlo"] or rt > prm["rhi"]:
                    rat_ko += 1
                if s2m > 0 and abs(s1m / prm["rat"] - s2m) / s2m > 0.12:
                    atr_ko += 1
        else:
            used.add(pid)
            n_sing += 1
    out = dict(n_pos=len(pos), n_pair=n_pair, n_sing=n_sing, rat_ko=rat_ko, atr_ko=atr_ko, v1ge02=v1ge02,
               med_lo=(statistics.median(lows) if lows else float("nan")), med_hi=(statistics.median(highs) if highs else float("nan")),
               med_rat=(statistics.median(rats) if rats else float("nan")), med_s1=(statistics.median(s1s) if s1s else float("nan")))
    out["nullo"] = n_pair > 0 and (rat_ko > n_pair / 2.0 or atr_ko > n_pair / 2.0)
    return out


def k1_verdetto(t, ko, prm):
    sog = float(prm["sog"])
    if ko["n_pair"] == 0:
        return "NON CALCOLABILE"
    if ko["nullo"]:
        return "NULLO"
    if sog <= 0:
        return "SOLO LETTURA"
    if t == "R265a":
        return "PASS" if ko["med_lo"] >= sog else ("FAIL" if ko["med_hi"] < sog else "NON RISOLTO")
    return "PASS" if ko["med_lo"] >= 1.15 * sog else ("FAIL" if ko["med_hi"] < 0.85 * sog else "NON RISOLTO")


def k1_r266_campione(pos, sym):
    """K1 a campione sul per-trade OOS (R266 par. 7 K1, classe 846): limite alto dello stop = R / (vol C q_min),
    R = saldo x 1%, q_min 0,80; sotto il cancello per UNA posizione = COSTO NON GARANTITO."""
    n_ko, lim_min = 0, float("inf")
    for p in pos:
        if p["vol"] <= 0:
            continue
        lim = (p["saldo"] * 0.010) / (p["vol"] * 100000.0 * 0.80)
        lim_min = min(lim_min, lim)
        if lim < K1_R266[sym]:
            n_ko += 1
    return n_ko, lim_min


def struttura(deals):
    return set((ct(d), d["deal_type"], round(d["price"], 6)) for d in deals)


def m123(cand_is, cand_oos, ctrl_is, ctrl_oos, uscita=False):
    """M1-M3 come leggi_r255.py par. 10, sul CSV (PF sui deal, EP = Profit/Trades): M1 PF OOS >= 1,10;
    M2 PF OOS >= controllo + 0,10 e EP > controllo (uscite: anche Profit > e DD <=); M3 concordanza IS e OOS
    (solo con le due gambe). None = NON VERIFICABILE."""
    m = dict(M1=None, M2=None, M3=None)
    if cand_oos is None or ctrl_oos is None:
        return m
    pf_c, pf_r = num(cand_oos["Profit Factor"]), num(ctrl_oos["Profit Factor"])
    ep_c = num(cand_oos["Profit"]) / max(1.0, num(cand_oos["Trades"]))
    ep_r = num(ctrl_oos["Profit"]) / max(1.0, num(ctrl_oos["Trades"]))
    m["M1"] = pf_c >= 1.10
    m2 = pf_c >= pf_r + 0.10 and ep_c > ep_r
    if uscita:
        m2 = m2 and num(cand_oos["Profit"]) > num(ctrl_oos["Profit"]) and num(cand_oos["Equity DD %"]) <= num(ctrl_oos["Equity DD %"])
    m["M2"] = m2
    if cand_is is not None and ctrl_is is not None:
        m["M3"] = (num(cand_is["Profit Factor"]) > num(ctrl_is["Profit Factor"])) and (pf_c > pf_r)
    return m


def m123_txt(m):
    return ", ".join("%s %s" % (k, "passa" if v is True else ("fallisce" if v is False else "NON VERIFICABILE")) for k, v in m.items())


def verdetto_rischio(violato, n, soglia_txt):
    """classe 804: una violazione boccia a qualunque n; 'RISCHIO PASSATO' solo con n >= 150 posizioni,
    altrimenti 'NON VIOLATO su n = X'."""
    if violato:
        return "VIOLATO (%s; boccia a qualunque n, Emendamento B)" % soglia_txt
    if n >= N_MERITO:
        return "RISCHIO PASSATO su n = %d >= %d (%s, classe 804)" % (n, N_MERITO, soglia_txt)
    return "NON VIOLATO su n = %d (RISCHIO PASSATO solo con n >= %d, classe 804; %s)" % (n, N_MERITO, soglia_txt)


def certificato(pf_ok, n_dd_ok, uscita_ok, gemelli_ok, tf_ok, pf_txt):
    """certificato di morte a 5 caselle (CLAUDE.md 09/09): PF, n+DD, uscita ad asse, gemelli, TF."""
    caselle = OrderedDict([("(1) PF", pf_ok), ("(2) n e DD", n_dd_ok), ("(3) uscita ad asse", uscita_ok), ("(4) gemelli", gemelli_ok), ("(5) TF", tf_ok)])
    manc = [k for k, v in caselle.items() if not v]
    verd = "NON ANCORA MISURATO (mancano: %s)" % ", ".join(manc) if manc else "certificato COMPLETO da questo round + archivio: un NO qui e' un NO con certificato"
    return "coperte da QUESTO round: %s; %s [%s]" % (", ".join(k for k, v in caselle.items() if v) or "nessuna", verd, pf_txt)


# ---------------------------------------------------------------------------
#  La raccolta (layout ESATTO della riga C)
# ---------------------------------------------------------------------------
class Raccolta:
    def __init__(self, root, archivi=None):
        self.root = root
        self.archivi = archivi
        self.note = []
        self._riep = None

    def p_csv(self, t, leg):
        j = JOBS[t]
        return os.path.join(self.root, "ROUND_" + t, "%s_%s_%s%s_%s.csv" % (j["e"], j["s"], leg, j["sm"], t))

    def p_pt(self, t, mg):
        j = JOBS[t]
        return os.path.join(self.root, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (j["e"], j["s"], mg))

    def p_prova(self, t):
        p = os.path.join(self.root, "ROUND_" + t, JOBS[t]["p"])
        if os.path.exists(p):
            return p, "raccolta"
        q = os.path.join(PROVE_REPO, JOBS[t]["p"])
        return (q, "repo prove/ (NON nella raccolta: P0 letto contro la copia del ramo, non contro quella del pin)") if os.path.exists(q) else (p, "ASSENTE")

    def p_referto(self, t):
        return os.path.join(self.root, "ROUND_" + t, "REFERTO_ROUND_%s.txt" % t)

    def lanciato(self, t):
        return os.path.isdir(os.path.join(self.root, "ROUND_" + t))

    def riepilogo(self):
        if self._riep is None:
            p = os.path.join(self.root, "RIEPILOGO_ROUND_CORTI_C.txt")
            self._riep = leggi_testo(p).splitlines() if os.path.exists(p) else []
        return self._riep

    def riga_riepilogo(self, prefisso):
        for ln in self.riepilogo():
            if ln.startswith(prefisso):
                return ln
        return ""

    def saltato_txt(self, t):
        ln = self.riga_riepilogo("FILE SALTATI")
        m = re.search(r"\b%s \(([^)]*)\)" % t, ln)
        return m.group(1) if m else ""

    def tetto_barre(self, t):
        p = self.p_referto(t)
        if not os.path.exists(p):
            return "REFERTO_ROUND assente"
        for ln in leggi_testo(p).splitlines():
            if ln.lower().startswith("tetto barre"):
                return re.sub(r"\s+", " ", ln.strip())
        return "riga 'tetto barre' non trovata"

    def p_ext(self, nome):
        """(csv, pt, fonte) di un esterno: ESTERNI/ della raccolta, poi --archivi, poi il repo (CORTI B)."""
        x = EXT[nome]
        csvn = "%s_%s_%s%s_%s.csv" % (x["e"], x["s"], x["lg"], x["sm"], nome)
        ptn = "abtg_trades_%s_%s_%s.csv" % (x["e"], x["s"], x["mg"])
        cands = [(os.path.join(self.root, "ESTERNI", csvn), os.path.join(self.root, "ESTERNI", ptn), "ESTERNI/ della raccolta")]
        for base in (self.archivi, ARCHIVI_REPO):
            if base:
                cands.append((os.path.join(base, "ROUND_" + nome, csvn), os.path.join(base, "PERTRADE", ptn), "archivio %s" % base))
                cands.append((os.path.join(base, csvn), os.path.join(base, ptn), "archivio %s" % base))
        for c, p, fonte in cands:
            if os.path.exists(c):
                return c, (p if os.path.exists(p) else None), fonte
        return None, None, "ASSENTE ovunque"

    def log_tester(self):
        lg = os.path.join(self.root, "LOG_TESTER")
        if not os.path.isdir(lg):
            return []
        return [os.path.join(lg, f) for f in sorted(os.listdir(lg)) if f.lower().endswith(".log")]


class PerTrade:
    """un per-trade letto con i suoi controlli (righe, magic, date, lato)."""

    def __init__(self, path, mg, sd, d0, d1):
        self.path = path
        self.deals = leggi_pertrade(path)
        self.n = len(self.deals)
        self.sum = sum(d["net"] for d in self.deals)
        self.vol = sum(d["vol"] for d in self.deals)
        self.n_mg = sum(1 for d in self.deals if str(d["magic"]) == str(mg))
        self.dmin = dstr(self.deals[0]["t"]) if self.deals else "nessuna"
        self.dmax = dstr(self.deals[-1]["t"]) if self.deals else "nessuna"
        self.l0 = [d for d in self.deals if sd != "" and d["deal_type"] != int(sd)]
        self.bad = (self.n == 0 or self.n_mg != self.n or self.dmin < d0 or self.dmax > d1)
        self.k = float("nan")
        self.dC = float("nan")
        self.cell = ""          # cella identificata (file a magic fisso)
        self.amb = ""           # celle ambigue (classe 850)
        self.trades = self.profit = "n.d."

    def pos(self, dep):
        return posizioni(self.deals, self.k, dep)


class File:
    """Un file del round: cancelli di nullita' rifatti qui (E0, asse, P0, C0, L0, G1)."""

    def __init__(self, rac, t):
        self.t, self.j, self.rac = t, JOBS[t], rac
        self.nullo, self.info = [], []
        self.rows = {}           # gamba -> righe
        self.pt = OrderedDict()  # magic -> PerTrade
        self.lanciato = rac.lanciato(t)
        self.saltato = ""
        if not self.lanciato:
            self.saltato = rac.saltato_txt(t) or "cartella ROUND_%s assente (SALTATO o non raccolto)" % t
            return
        j = self.j
        legs = ["IS", "OOS"] if j["lg"] == "IO" else [j["lg"]]
        self.legs = legs
        for leg in legs:
            p = rac.p_csv(t, leg)
            if not os.path.exists(p) or os.path.getsize(p) == 0:
                self.nullo.append("E0: CSV _%s atteso ASSENTE o 0 byte (%s)" % (leg, os.path.basename(p)))
                continue
            rows = leggi_csv(p)
            npos = sum(1 for r in rows if re.match(r"^[1-9][0-9]*$", str(r.get("Trades", "")).strip()))
            if len(rows) != j["nr"] or npos != j["nr"]:
                self.nullo.append("E0: CSV _%s con %d righe (Trades>0 su %d), attese %d" % (leg, len(rows), npos, j["nr"]))
                continue
            self.rows[leg] = rows
            axv = sorted(num(r.get(j["ax"])) for r in rows)
            axe = sorted(float(v) for v in j["av"])
            if any(abs(a - b) > EPS for a, b in zip(axv, axe)):
                self.nullo.append("ASSE %s nel CSV _%s = %s, atteso %s" % (j["ax"], leg, axv, axe))
        # gamba degenere / moncone: informativo
        for leg in ("IS", "OOS"):
            if leg not in legs:
                p = rac.p_csv(t, leg)
                stato = "assente" if not os.path.exists(p) else ("0 byte" if os.path.getsize(p) == 0 else "presente (ha scritto righe: si guarda nel REFERTO, non conta)")
                self.info.append("_%s %s: %s, ATTESO" % (leg, stato, "moncone IS" if leg == "IS" else "gamba OOS DEGENERE"))
        self.tetto = rac.tetto_barre(t)
        # P0: pin del file prova contro OGNI riga di OGNI CSV atteso (classe 780)
        pv, fonte_pv = rac.p_prova(t)
        self.fonte_prova = fonte_pv
        if fonte_pv == "ASSENTE":
            self.nullo.append("P0: file prova %s ASSENTE (raccolta e repo)" % j["p"])
        else:
            pin, asse, _ = leggi_pin_prova(pv)
            if len(pin) != j["np"] or asse != [j["ax"]]:
                self.nullo.append("P0: PIN DEL FILE PROVA NON LEGGIBILI (%d numerici su %d attesi, asse %s)" % (len(pin), j["np"], "/".join(asse)))
            else:
                ko, n_conf, manc = [], 0, set()
                for leg, rows in self.rows.items():
                    for r in rows:
                        for nome, v in pin.items():
                            if nome not in r:
                                manc.add(nome)
                                continue
                            n_conf += 1
                            if not (abs(num(r[nome]) - v) <= EPS):
                                ko.append("%s:%s=[%s] atteso %g" % (leg, nome, r[nome], v))
                if ko:
                    self.nullo.append("P0 PIN DAL CSV DIVERSO (%d valori: %s)" % (len(ko), "; ".join(ko[:6])))
                elif manc:
                    self.nullo.append("P0 PIN DAL CSV NON LEGGIBILE (colonne assenti: %s)" % ", ".join(sorted(manc)))
                elif self.rows:
                    self.info.append("P0 pin dal CSV ok (%d confronti + asse), prova da %s" % (n_conf, fonte_pv))
        # C0 per-trade
        main = self.rows.get(j["pl"])
        for mg in (j["pt"] or [j["pid"]]):
            q = rac.p_pt(t, mg)
            if not os.path.exists(q):
                self.nullo.append("C0: per-trade %s MANCANTE" % mg)
                continue
            try:
                po = PerTrade(q, mg, j["sd"], j["d0"], j["d1"])
            except (ValueError, KeyError) as e:
                self.nullo.append("C0: per-trade %s illeggibile (%s)" % (mg, e))
                continue
            self.pt[mg] = po
            if po.bad:
                self.nullo.append("C0 PER-TRADE NON BUONO %s (righe %d, magic %d, chiusure %s -> %s; attese > 0 righe fra %s e %s)" % (mg, po.n, po.n_mg, po.dmin, po.dmax, j["d0"], j["d1"]))
                continue
            if main is None:
                continue
            if j["pt"]:   # gemella: cella = il suo magic
                r = cella(main, j["ax"], mg)
                if r is None:
                    self.nullo.append("cella %s=%s non trovata nel CSV _%s" % (j["ax"], mg, j["pl"]))
                    continue
                ok, dC, k = k_rule(j["kr"], po.sum, num(r["Profit"]), po.vol, po.n, int(num(r["Trades"])))
                po.k, po.dC, po.cell, po.trades, po.profit = k, dC, str(mg), r["Trades"], r["Profit"]
                if not ok:
                    self.nullo.append("C0 SOMMA O RIGHE DIVERSE DAL CSV sul per-trade %s (righe %d contro Trades %s, somma - Profit %.2f, k %.4f; regola: %s)" % (mg, po.n, r["Trades"], dC, k, k_txt(j["kr"])))
            else:         # magic fisso: IDENTIFICAZIONE stretto-poi-largo (classi 850/855)
                regole = ["usd", "dax"] if j["kr"] == "dax" else [j["kr"]]
                mtc = []
                for kr in regole:
                    for r in main:
                        ok, dC, k = k_rule(kr, po.sum, num(r["Profit"]), po.vol, po.n, int(num(r["Trades"])))
                        if ok:
                            mtc.append((r, dC, k, kr))
                    if mtc:
                        break
                if not mtc:
                    self.nullo.append("C0 KO: il per-trade %s NON corrisponde a NESSUNA cella del CSV _%s (righe %d, somma %.2f, lotti %.2f; regola: %s) -> NULLO (classe 850)" % (mg, j["pl"], po.n, po.sum, po.vol, k_txt(j["kr"])))
                    continue
                uguali = all(abs(num(x[0]["Trades"]) - num(mtc[0][0]["Trades"])) <= EPS and abs(num(x[0]["Profit"]) - num(mtc[0][0]["Profit"])) <= 0.005 for x in mtc)
                if uguali:
                    r, dC, k, kr = mtc[0]
                    po.cell, po.dC, po.k, po.trades, po.profit = str(r[j["ax"]]), dC, k, r["Trades"], r["Profit"]
                    self.info.append("per-trade %s IDENTIFICATO (classe 850, regola %s): cella %s=%s (Trades %s, Profit %s, k %.4f)%s%s" % (
                        mg, kr, j["ax"], po.cell, r["Trades"], r["Profit"], k,
                        " [%d celle con Trades e Profit IDENTICI: manopola inerte, indifferente quale]" % len(mtc) if len(mtc) > 1 else "",
                        "" if abs(num(po.cell) - num(j["pav"])) <= EPS else " -- NON la cella attesa %s: le letture sul per-trade si fanno su QUESTA cella" % j["pav"]))
                else:
                    po.amb = ", ".join("%s=%s (Profit %s)" % (j["ax"], x[0][j["ax"]], x[0]["Profit"]) for x in mtc)
                    self.info.append("per-trade %s AMBIGUO (classe 850): torna con %d celle DIVERSE (%s): le letture sul per-trade NON si fanno, il file NON e' nullo" % (mg, len(mtc), po.amb))
        # L0 lato
        if j["sd"] != "":
            for mg, po in self.pt.items():
                if po.l0:
                    d = po.l0[0]
                    self.nullo.append("L0: %d deal con deal_type diverso da %s sul per-trade %s (primo: %s deal_type %d) = pin di lato NON arrivato" % (len(po.l0), j["sd"], mg, ct(d), d["deal_type"]))
        # G1 gemelle
        if len(j["pt"]) == 2 and all(m in self.pt and not self.pt[m].bad for m in j["pt"]) and main is not None:
            a, b = (cella(main, j["ax"], m) for m in j["pt"])
            for leg, rows in self.rows.items():
                ra, rb = (cella(rows, j["ax"], m) for m in j["pt"])
                if ra is None or rb is None:
                    self.nullo.append("G1: righe gemelle non trovate nel _%s" % leg)
                    continue
                for cn, tol in (("Trades", EPS), ("Profit Factor", 0.00005), ("Profit", 0.05), ("Equity DD %", 0.01)):
                    if abs(num(ra[cn]) - num(rb[cn])) > tol + 1e-9:
                        self.nullo.append("G1: CSV _%s gemelle diverse su %s (%s contro %s)" % (leg, cn, ra[cn], rb[cn]))
            da, db = (self.pt[m].deals for m in j["pt"])
            if len(da) != len(db):
                self.nullo.append("G1: per-trade gemelli con righe diverse (%d contro %d)" % (len(da), len(db)))
            else:
                for i, (x, y) in enumerate(zip(da, db)):
                    if (ct(x), x["pid"], x["deal_type"], x["vol"], x["price"]) != (ct(y), y["pid"], y["deal_type"], y["vol"], y["price"]) or abs(x["net"] - y["net"]) > 0.01:
                        self.nullo.append("G1: per-trade gemelli diversi alla riga %d" % (i + 1))
                        break
            ka, kb = (self.pt[m].k for m in j["pt"])
            if j["kr"] != "usd" and not (math.isnan(ka) or math.isnan(kb)) and abs(ka - kb) > 0.01:
                self.nullo.append("G1: k della commissione diverso fra gemelle (%.3f contro %.3f)" % (ka, kb))

    @property
    def ok(self):
        return self.lanciato and not self.nullo

    def r(self, leg, val):
        return cella(self.rows.get(leg, []), self.j["ax"], val)

    def pt0(self):
        """il per-trade che si legge: la prima gemella, o il magic fisso se IDENTIFICATO (non ambiguo)."""
        if self.j["pt"]:
            return self.pt.get(self.j["pt"][0])
        po = self.pt.get(self.j["pid"])
        return po if (po is not None and po.cell != "" and not po.bad) else None


class Esterno:
    """G0 di un'altra riga: CSV + per-trade identificato (classe 850), se presenti."""

    def __init__(self, rac, nome):
        self.nome, self.x = nome, EXT[nome]
        self.csv, self.pt, self.cell, self.k = None, None, "", float("nan")
        c, p, fonte = rac.p_ext(nome)
        self.fonte = fonte
        if c is None:
            self.txt = "%s: CSV _%s ASSENTE (ESTERNI/, --archivi, repo): G0 ESTERNO NON VERIFICABILE, si legge nel referto di quel round" % (nome, self.x["lg"])
            return
        rows = leggi_csv(c)
        if len(rows) != self.x["nr"]:
            self.txt = "%s: CSV _%s con %d righe (attese %d) in %s: NON BUONO" % (nome, self.x["lg"], len(rows), self.x["nr"], fonte)
            return
        self.csv = rows
        if p is None:
            self.txt = "%s: CSV presente (%s) ma per-trade %s ASSENTE: le letture sul per-trade restano NON VERIFICABILI" % (nome, fonte, self.x["mg"])
            return
        po = PerTrade(p, self.x["mg"], "", self.x["d0"], self.x["d1"])
        if po.bad:
            self.txt = "%s: per-trade %s NON BUONO (righe %d, magic %d, chiusure %s -> %s)" % (nome, self.x["mg"], po.n, po.n_mg, po.dmin, po.dmax)
            return
        regole = ["usd", "dax"] if self.x["kr"] == "dax" else [self.x["kr"]]
        mtc = []
        for kr in regole:
            for r in rows:
                ok, dC, k = k_rule(kr, po.sum, num(r["Profit"]), po.vol, po.n, int(num(r["Trades"])))
                if ok:
                    mtc.append((r, dC, k))
            if mtc:
                break
        self.pt = po
        if not mtc:
            self.txt = "%s: per-trade %s NON IDENTIFICATO contro nessuna riga del CSV (classe 850): non si legge" % (nome, self.x["mg"])
            self.pt = None
            return
        if not all(abs(num(x[0]["Trades"]) - num(mtc[0][0]["Trades"])) <= EPS and abs(num(x[0]["Profit"]) - num(mtc[0][0]["Profit"])) <= 0.005 for x in mtc):
            self.txt = "%s: per-trade AMBIGUO (classe 850): torna con piu' righe DIVERSE: non si legge" % nome
            self.pt = None
            return
        self.cell = str(mtc[0][0][self.x["ax"]])
        self.k = po.k = mtc[0][2]
        self.txt = "%s: CSV e per-trade %s presenti (%s), %d righe, %d posizioni, chiusure %s -> %s -> IDENTIFICATO cella %s=%s (k %.4f)" % (
            nome, self.x["mg"], fonte, po.n, n_pos(po.deals), po.dmin, po.dmax, self.x["ax"], self.cell, self.k)

    def riga(self, val):
        return cella(self.csv, self.x["ax"], val) if self.csv else None


class Referto:
    def __init__(self):
        self.L, self.esiti = [], OrderedDict()

    def add(self, *ls):
        self.L.extend(ls)

    def testo(self):
        return "\n".join(self.L) + "\n"


# ---------------------------------------------------------------------------
#  Misure comuni sul per-trade di una cella (posizioni, PF con k, DD chiuso, peggior giornata)
# ---------------------------------------------------------------------------
def misure_pt(po, dep, dlo="", dhi=""):
    q = pf_win(po.deals, dlo, dhi, po.k)
    ch = dd_chiuso(curva_saldo(po.deals, po.k, dep), dep)
    pg = peggior_giornata(po.deals, po.k, dep)
    return dict(n=q["n"], pf=q["pf"], net=q["net"], ep=q["ep"], dd=ch["dd"], pk=ch["pk"], fo=ch["fo"], pegg=pg["pct"], pegg_data=pg["data"], kdp=(po.n / q["n"] if q["n"] else float("nan")))


def misure_txt(m, k):
    return ("posizioni %d, PF in posizioni (k %.4f tolto) %s, EP %.2f EUR/pos, DD a saldo chiuso %.3f %% (picco %s, fondo %s), peggior giornata %.3f %% (%s, denominatore = saldo a inizio giornata), deal/posizione %.3f [MISURATO dal per-trade]"
            % (m["n"], (0.0 if math.isnan(k) else k), fpf(m["pf"]), m["ep"], m["dd"], dstr(m["pk"]) if m["pk"] else "-", dstr(m["fo"]) if m["fo"] else "-", m["pegg"], m["pegg_data"] or "-", m["kdp"]))


def tab_taglie(dd, base, R, etichetta):
    """tabella DESCRITTIVA del DD alle taglie (pavimento moltiplicativo / tetto lineare, R193b B3) -- NESSUNA PROPOSTA."""
    R.add("- DD alle taglie [DERIVATO, R193b B3, da %s a %.2f%%]: %s -- **NESSUNA PROPOSTA DI TAGLIA**" % (
        etichetta, base, "; ".join("%.2f%%: %.2f-%.2f%%" % (f, *dd_taglia(dd, f, base)) for f in (0.5, 1.0, 1.5, 2.0) if f != base)))


def anni_pos(deals, k, anni):
    return ", ".join("%s: %d pos PF %s" % (y, q["n"], fpf(q["pf"])) for y, q in ((y, pf_win(deals, "%s.01.01" % y, "%s.12.31" % y, k)) for y in anni))


# ---------------------------------------------------------------------------
#  LA LETTURA
# ---------------------------------------------------------------------------
def lettura(rac):
    R = Referto()
    F = OrderedDict((t, File(rac, t)) for t in JOBS)
    EX = OrderedDict((n, Esterno(rac, n)) for n in EXT)
    R.add("# LETTURA DEL ROUND CORTI C -- R264 (EMA200 H4: G0 tick, ponte AUDJPY, griglie OHLC) + R265 (EURUSD solo corto: G0+K1, walk-forward) + R266 (box asiatico GBPUSD/EURUSD) + R260d (oro solo long col trend dell'oro) + R267 (11 manopole a costo zero; R267a ESCLUSO)",
          "", "Generato da `backtest_pipeline/leggi_round_corti_c.py` sulla raccolta `%s`." % rac.root,
          "Criteri congelati PRIMA dei numeri: `prove/R264_TESTA.txt.in` par. 5-9, `prove/R265_TESTA.txt.in` par. 2-4, `prove/R266a_asia_box_GBPUSD_TESTA.txt` par. 5-8, "
          "`prove/R260d_oro_770402_solo_long_trend_oro.txt` par. 3-4, `prove/R267a_news_oro_770402.txt` par. 0 e `prove/R267_GENERA.py` (B/C/V/E/U/D). "
          "Etichette: [MISURATO] dal CSV/per-trade della raccolta; [DERIVATO] da una formula della testa; [STIMA]; [NON MISURATO]; [NON VERIFICABILE]. "
          "Posizioni contate per position_id; sul forex/oro ogni saldo toglie k x volume (classe 844: k = (somma net - Profit)/lotti). "
          "**R4/B6/C6/V5/U6/D6/E4: NESSUNA cella si promuove. NESSUNA PROPOSTA DI TAGLIA: ogni riga di taglia e' un riferimento, non una proposta. Nessun preset, EA, sedia o conto e' toccato.**",
          "", "Pre-lettura della riga (RIEPILOGO_ROUND_CORTI_C.txt): %s -- si RILEGGE, non si crede: i cancelli qui sotto sono rifatti dai CSV e dai per-trade." % (
              "presente, %d righe" % len(rac.riepilogo()) if rac.riepilogo() else "ASSENTE"), "")
    # --- 0. cancelli
    R.add("## 0. Cancelli di nullita' (secondo strato, indipendente dalla riga)", "",
          "| file | lanciato | esito | motivi / note | tetto barre |", "|---|---|---|---|---|")
    n_nulli = n_salt = 0
    for t, f in F.items():
        if not f.lanciato:
            n_salt += 1
            R.add("| %s | NO | SALTATO / non nella raccolta | %s | - |" % (t, f.saltato.replace("|", "/")))
        else:
            if not f.ok:
                n_nulli += 1
            R.add("| %s | si | %s | %s | %s |" % (t, "NON NULLO" if f.ok else "**NULLO**", ("; ".join(f.nullo) if f.nullo else "E0, asse, P0, C0, L0, G1 ok") + ("; " + "; ".join(f.info) if f.info else ""), f.tetto))
    R.add("", "fonte: `ROUND_<t>/<EA>_<sim>_<gamba><_ohlc>_<t>.csv`, `ROUND_<t>/<prova>` (P0), `PERTRADE/abtg_trades_<EA>_<sim>_<magic>.csv`, `ROUND_<t>/REFERTO_ROUND_<t>.txt` (tetto barre). "
          "Regole: E0 righe attese e Trades>0 (classe 766); P0 pin dal CSV (classe 780); C0 righe = Trades e somma per simbolo (classi 844/855); identificazione stretto-poi-largo, AMBIGUO non nullo (classe 850); L0 lato; G1 gemelle.")
    # R267a: ESCLUSO E DICHIARATO
    r267a = os.path.isdir(os.path.join(rac.root, "ROUND_R267a"))
    R.add("- **R267a** (`%s`): %s" % (R267A["p"], (
        "cartella ROUND_R267a PRESENTE: INATTESO -- la testa par. 6-A lo esclude (LoadNews senza FILE_COMMON: due celle identiche a R260c = misura del NULLA); si legge SOLO se il par. 6-A e' stato chiuso per iscritto, e qui non risulta: NON LETTO"
        if r267a else "ASSENTE, ed e' ATTESO: ESCLUSO E DICHIARATO dalla riga e dalla testa par. 6-A (canale news aperto). NON e' un file NULLO per guasto: resta in coda finche' il par. 6-A non e' chiuso (A1 codice o A2 sandbox).")))
    R.esiti["r267a"] = "INATTESO" if r267a else "ESCLUSO_ATTESO"
    R.esiti["n_nulli"], R.esiti["n_salt"] = n_nulli, n_salt
    # D0 tasso IS/OOS (R264 par. 8 S0) sulle griglie e R265b
    R.add("", "**D0 DATI (R264 par. 8 S0: tasso IS in deal/anno fra 0,5 e 2,0 volte il tasso OOS della stessa cella, altrimenti storico M1 sospetto -> NULLO)**")
    for t in [x for g in GRID.values() for x in g["f"] + [g["x4"]]] + ["R265b"]:
        f = F[t]
        if not f.ok:
            R.add("- %s: D0 NON VERIFICABILE (NULLO o SALTATO)" % t)
            continue
        j = f.j
        yI = (datetime.strptime(j["dm"], "%Y.%m.%d") - datetime.strptime(j["da"], "%Y.%m.%d")).days / 365.25 + 1 / 365.25
        yO = (datetime.strptime(j["d1"], "%Y.%m.%d") - datetime.strptime(j["d0"], "%Y.%m.%d")).days / 365.25 + 1 / 365.25
        bad, det = [], []
        for av in j["av"]:
            ri, ro = f.r("IS", av), f.r("OOS", av)
            if ri is None or ro is None:
                bad.append("%s riga mancante" % av)
                continue
            rI, rO = num(ri["Trades"]) / yI, num(ro["Trades"]) / yO
            rt = rI / rO if rO > 0 else float("nan")
            det.append("%s: %.1f/%.1f = %.2f" % (av, rI, rO, rt))
            if math.isnan(rt) or rt < 0.5 or rt > 2.0:
                bad.append("%s rapporto %.2f" % (av, rt))
        if bad:
            f.nullo.append("D0 TASSO IS/OOS FUORI [0,5 ; 2,0] (%s)" % ", ".join(bad))
        R.add("- %s (IS %.2f anni, OOS %.2f): %s -> %s" % (t, yI, yO, " | ".join(det), "D0 ok" if not bad else "**D0 KO: file NULLO** (%s)" % ", ".join(bad)))
    # G2 incrociato (R264 par. 6.3)
    R.add("", "**G2 INCROCIATO (R264 par. 6.3: cella TP1Pct=50 del file x4 == cella O1=0,20 del file x2, IS e OOS al centesimo)**")
    for gk, g in GRID.items():
        x2, x4 = F[g["f"][1]], F[g["x4"]]
        if not (x2.ok and x4.ok):
            R.add("- %s: G2 NON VERIFICABILE (%s o %s NULLO/SALTATO)" % (g["sym"], g["f"][1], g["x4"]))
            continue
        dif = []
        for leg in ("IS", "OOS"):
            d = cmp4(x4.r(leg, 50), x2.r(leg, 0.20))
            if d:
                dif.append("%s: %s" % (leg, "; ".join(d)))
        if dif:
            x2.nullo.append("G2 INCROCIATO KO con %s" % g["x4"])
            x4.nullo.append("G2 INCROCIATO KO con %s" % g["f"][1])
            R.add("- %s: **G2 KO** (%s) -> %s e %s NULLI (non separabile quale)" % (g["sym"], " / ".join(dif), g["f"][1], g["x4"]))
        else:
            R.add("- %s: %s TP1Pct=50 == %s O1=0,20 in IS e OOS -> G2 ok" % (g["sym"], g["x4"], g["f"][1]))
    R.add("")
    sez_r264(rac, F, EX, R)
    sez_r265b(F, EX, R)
    sez_r266(F, R)
    sez_r260d(F, EX, R)
    sez_r267(F, EX, R)
    sez_finale(F, R)
    return R


# ---------------------------------------------------------------------------
#  R264 / R265a: G0, K1, ponte, griglie
# ---------------------------------------------------------------------------
def g0_livello(f, an):
    """bande di R264 par. 5 / R265 par. 3: 0 VERDE, 1 GIALLO, 2 ROSSO, 3 NON VERIFICABILE."""
    if not f.ok:
        return 3, None
    r = f.r("OOS", f.j["pt"][0])
    if r is None:
        return 3, None
    dn = abs(num(r["Trades"]) - an["tr"])
    dp = abs(num(r["Profit Factor"]) - an["pf"])
    dd = abs(num(r["Equity DD %"]) - an["dd"]) / an["dd"]
    lv = 0 if (dn <= 0.01 * an["tr"] and dp <= 0.020 and dd <= 0.05) else (1 if (dn <= 0.03 * an["tr"] and dp <= 0.050) else 2)
    return lv, dict(r=r, dn=dn, dp=dp, dd=dd)


G0_NOME = ["VERDE (il banco rifa' l'archivio: |dn| <= 1%, |dPF| <= 0,020, DD entro +-5%)", "GIALLO (|dn| <= 3% e |dPF| <= 0,050)", "ROSSO: il banco NON rifa' l'archivio", "NON VERIFICABILE (file NULLO o SALTATO)"]


def sez_r264(rac, F, EX, R):
    R.add("## 1. R264 / R265a -- G0 DEI BANCHI (testa R264 par. 5, R265 par. 3) e K1 DAL LOTTO (classe 846)", "")
    G0, K1 = {}, {}
    for t in ("R264c", "R264d", "R264a", "R264b", "R265a"):
        f, an = F[t], ANC_G0[t]
        lv, g = g0_livello(f, an)
        G0[t] = lv
        if g is None:
            R.add("- **G0 %s %s: %s**" % (t, f.j["s"], G0_NOME[3]))
        else:
            causa = {"R264d": " (causa NOMINATA prima, par. 5: lotto 0,01-0,02 a 10000 sull'oro, parziale che non parte, BE di 344a11b9; contro-esempio nel K1: gambe 1 con volume >= 0,02)",
                     "R265a": " -> l'IPOTESI sul banco della scansione e' FALSA: R265b perde l'ancora ma resta leggibile da solo, K1 resta valido"}.get(t, ": le letture OOS contro il genetico (ponte, OOS delle griglie) diventano NON CONFRONTABILI; l'IS resta leggibile da solo") if lv == 2 else ""
            R.add("- **G0 %s %s** gemella %s OOS %s -> %s: %s [MISURATO] contro %s (n %d, PF %.5f, DD %.4f, Profit %.2f): |dn| %.0f (1%% = %.2f, 3%% = %.2f), |dPF| %.3f, dDD rel %.3f -> **%s**%s" % (
                t, f.j["s"], f.j["pt"][0], f.j["d0"], f.j["d1"], riga_txt(g["r"]), an["nome"], an["tr"], an["pf"], an["dd"], an["pr"], g["dn"], 0.01 * an["tr"], 0.03 * an["tr"], g["dp"], g["dd"], G0_NOME[lv], causa))
        # K1
        prm = K1PAR[t]
        po = f.pt0() if f.ok else None
        if po is None:
            K1[t] = dict(ver="NON CALCOLABILE", txt="per-trade della gemella assente o file NULLO")
            R.add("  - K1 %s: NON CALCOLABILE (%s)" % (t, K1[t]["txt"]))
            continue
        pos = po.pos(f.j["dp"])
        ko = k1_lotto(pos, prm)
        ver = k1_verdetto(t, ko, prm)
        sc = prm["sc"]
        K1[t] = dict(ver=ver, ko=ko)
        extra = ""
        if t == "R265a" and ver == "PASS":
            extra = " (PASS al metro del logger 26,54, SOTTO il metro della sonda 34,56: non un PASS nudo)" if ko["med_lo"] < 0.003456 else " (sopra anche il metro della sonda 34,56)"
        elif ver == "NON RISOLTO":
            extra = " (la soglia sta fra le due mediane o entro +-15%: INDICATIVO, serve la lettura diretta: corsa singola con InpVerbose o ATR(14) H4 sul grafico)"
        elif ver == "SOLO LETTURA":
            extra = " (nessuna soglia decidibile su questo simbolo: numero riportato)"
        elif ver == "NULLO":
            extra = " (CONTRO-ESEMPIO INTERNO FALLITO: identificazione delle gambe sbagliata)"
        R.add("  - K1 %s dal LOTTO [DERIVATO dal per-trade %s, R = saldo x 0,5%% per gamba, k %.4f tolto]: posizioni %d, coppie gamba1/gamba2 %d, singole %d, vol2/vol1 mediano %s (atteso %.2f, fuori [%.2f ; %.4g] in %d coppie), ATR da gamba 1 e 2 oltre +-12%% in %d coppie; stop gamba 2 MEDIANO: limite basso %.2f %s, alto %.2f %s (gamba 1 ~%.2f); soglia: %s -> **K1 %s**%s%s" % (
            t, po.path.split(os.sep)[-1], po.k, ko["n_pos"], ko["n_pair"], ko["n_sing"], f3(ko["med_rat"]), prm["rat"], prm["rlo"], prm["rhi"], ko["rat_ko"], ko["atr_ko"],
            ko["med_lo"] * sc if not math.isnan(ko["med_lo"]) else float("nan"), prm["un"], ko["med_hi"] * sc if not math.isnan(ko["med_hi"]) else float("nan"), prm["un"], ko["med_s1"] * sc if not math.isnan(ko["med_s1"]) else float("nan"), prm["dec"], ver, extra,
            ("; gambe 1 con volume >= 0,02: %d su %d (contro-esempio della causa nominata per il GIALLO/ROSSO d'oro: se >= 0,02 la causa lotto e' SBAGLIATA)" % (ko["v1ge02"], ko["n_pair"])) if t == "R264d" else ""))
        m = misure_pt(po, f.j["dp"])
        R.add("  - %s: %s" % (t, misure_txt(m, po.k)))
        R.esiti["k1_" + t] = ver
    for t in G0:
        R.esiti["g0_" + t] = ["VERDE", "GIALLO", "ROSSO", "NV"][G0[t]]
    # metro tick
    ln = rac.riga_riepilogo("METRO TICK EMA200")
    R.add("", "- metro tick EMA200 H4 (dalla riga, si riporta): %s" % (ln[:200] if ln else "[NON TROVATO nel RIEPILOGO]"), "")
    # --- ponte
    R.add("## 2. R264b1 -- IL PONTE AUDJPY (testa par. 9: le 4 celle di R139a sulla finestra del genetico, a OHLC)", "")
    f = F["R264b1"]
    if not f.ok:
        R.add("- NON VERIFICABILE (R264b1 %s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
        R.esiti["ponte"] = "NV"
    else:
        n_cf = n_sm = 0
        for tp in (1.5, 2.0, 2.5, 3.0):
            r = f.r("OOS", tp)
            pf = num(r["Profit Factor"])
            n_cf += pf >= 1.45
            n_sm += pf < 1.25
            R.add("- TP %.1f: %s [MISURATO] -- archivio: %s" % (tp, riga_txt(r), ANC_PONTE[tp]))
        ver = "CONFERMA: vince R139a, il 1,514 e' una FETTA D'EPOCA misurata (AUDJPY resta in archivio, poggia sul RISCHIO 2016-2026: DD OOS 16,89-20,44% @1%, Emendamento B)" if n_cf >= 3 else (
            "SMENTITA: OHLC e tick NON concordano sulla stessa finestra, il verdetto di R139a perde il banco -> AUDJPY NON ANCORA MISURATO (non resuscitato)" if n_sm >= 3 else "NON CONCLUDENTE (ne' 3 su 4 >= 1,45 ne' 3 su 4 < 1,25)")
        po = f.pt0()
        R.add("- celle con PF >= 1,45: %d su 4; sotto 1,25: %d su 4 -> **%s**%s" % (n_cf, n_sm, ver, " [G0 AUDJPY ROSSO: contro il genetico NON CONFRONTABILE, il numero si scrive e non decide]" if G0["R264b"] == 2 else ""),
              "- per-trade 796512: %s" % ("cella InpTP_RR=%s -> %s" % (po.cell, misure_txt(misure_pt(po, 10000), po.k)) if po else "non identificato o ambiguo"),
              "- previsione della testa: CONFERMA. Riserva scritta al par. 2.1: InpTP1Pct su AUDJPY resta MAI MISURATO (casella 3 riempita col TP_RR, che il motore scavalca).")
        R.esiti["ponte"] = ver.split(":")[0].split(" ")[0]
    R.add("")
    # --- griglie
    R.add("## 3. R264 -- LE GRIGLIE 3 x 3 (testa par. 6-8: CENTRO = la cella di MEZZO O1 0,20 / O2 centrale, MAI il picco; classe 845)", "")
    for gk, g in GRID.items():
        sez_griglia(F, R, g, G0[g["g0"]])
    R.add("")


def sez_griglia(F, R, g, g0lv):
    sym = g["sym"]
    R.add("### 3.%s %s (G0 %s: %s) -- %s" % (gk_of(g), sym, g["g0"], ["VERDE", "GIALLO", "ROSSO", "NON VERIFICABILE"][g0lv], g["regime"]), "")
    files = [F[t] for t in g["f"]]
    x4 = F[g["x4"]]
    if not all(f.ok for f in files):
        R.add("- S2 NON VERIFICABILE: un file della griglia e' NULLO o SALTATO (%s)" % ", ".join("%s %s" % (f.t, "ok" if f.ok else ("NULLO" if f.lanciato else "SALTATO")) for f in files))
        R.esiti["griglia_" + sym] = "NV"
    else:
        pfm, trm, ddm, pfo, tro, ddo = {}, {}, {}, {}, {}, {}
        R.add("| O1 \\ O2 | " + " | ".join("O2 %.1f IS PF / n / DD -- OOS PF / n / DD" % o for o in g["o2"]) + " |", "|---|---|---|---|")
        miss = 0
        inert = []
        for ic, f in enumerate(files):
            trs, pfs = [], []
            for o1 in (0.1, 0.2, 0.3):
                ri, ro = f.r("IS", o1), f.r("OOS", o1)
                if ri is None or ro is None:
                    miss += 1
                    continue
                k = (o1, ic)
                pfm[k], trm[k], ddm[k] = num(ri["Profit Factor"]), num(ri["Trades"]), num(ri["Equity DD %"])
                pfo[k], tro[k], ddo[k] = num(ro["Profit Factor"]), num(ro["Trades"]), num(ro["Equity DD %"])
                trs.append(trm[k])
                pfs.append(pfm[k])
            if len(trs) == 3 and (max(trs) - min(trs)) < 5 and (max(pfs) - min(pfs)) < 0.010:
                inert.append(f.t)
        for o1 in (0.1, 0.2, 0.3):
            R.add("| O1 %.2f | " % o1 + " | ".join(("%s / %d / %.2f -- %s / %d / %.2f" % (fpf(pfm[(o1, ic)]), trm[(o1, ic)], ddm[(o1, ic)], fpf(pfo[(o1, ic)]), tro[(o1, ic)], ddo[(o1, ic)])) if (o1, ic) in pfm else "MANCANTE" for ic in range(3)) + " |")
        R.add("", "fonte: `ROUND_%s..%s/*_IS_ohlc_*.csv` e `*_OOS_ohlc_*.csv` [MISURATO dal CSV, PF sui deal]; %s" % (g["f"][0], g["f"][2], REGIMI["R264OOS"]))
        if miss:
            R.add("- S2 NON VERIFICABILE: %d celle mancanti" % miss)
            R.esiti["griglia_" + sym] = "NV"
        else:
            mz = pfm[(0.2, 1)]
            r10, r20, r30 = (sum(pfm[(o, ic)] for ic in range(3)) / 3.0 for o in (0.1, 0.2, 0.3))
            c0, c1, c2 = (sum(pfm[(o, ic)] for o in (0.1, 0.2, 0.3)) / 3.0 for ic in range(3))
            bordo = [n for cond, n in ((r10 >= r20 + 0.08, "fila O1 0,10"), (r30 >= r20 + 0.08, "fila O1 0,30"), (c0 >= c1 + 0.08, "colonna O2 %.1f" % g["o2"][0]), (c2 >= c1 + 0.08, "colonna O2 %.1f" % g["o2"][2])) if cond]
            n110 = sum(1 for v in pfm.values() if v >= 1.10)
            vic = [pfm[(0.1, 1)], pfm[(0.3, 1)], pfm[(0.2, 0)], pfm[(0.2, 2)]]
            vic_ok = all(v >= 1.00 for v in vic)
            passa = not bordo and mz >= 1.10 and n110 >= 6 and vic_ok
            solido = passa and mz >= 1.27
            nIS, nOOS, ddI, ddO, pfoM = trm[(0.2, 1)], tro[(0.2, 1)], ddm[(0.2, 1)], ddo[(0.2, 1)], pfo[(0.2, 1)]
            picco = max(pfm, key=lambda k: pfm[k])
            s4 = mz < 1.00 and pfoM >= 1.10
            banda = ("H_MOTORE (IS al centro 1,15-1,40)" if 1.15 <= mz <= 1.40 else "H_FETTA (IS al centro 0,85-1,08: il genetico ha trovato il 2024-26)" if 0.85 <= mz <= 1.08
                     else "ZONA GRIGIA 1,08-1,15: NON CONCLUDENTE" if 1.08 < mz < 1.15 else "FUORI dalle due bande (%.3f): se e' alto il primo sospetto e' un baco o un pin non arrivato" % mz)
            ver = ("BORDO (%s)" % ", ".join(bordo) if bordo else "NO PER RISCHIO (S3)" if (ddI > MURO_1PCT or ddO > MURO_1PCT) else "REGIME, non edge (S4: IS < 1,00 e OOS >= 1,10, lo schema R139b)" if s4
                   else "SOSPESO (S1: n IS al mezzo %d < %d deal)" % (nIS, DEAL_MERITO) if nIS < DEAL_MERITO else "PASSA LO SCREENING, SOLIDO (PF IS mezzo >= 1,27)" if solido
                   else "PASSA LO SCREENING (non solido: fra 1,10 e 1,27 un tick puo' riportarlo sotto 1,10)" if passa else "NO PER MERITO (IS < 1,10 al mezzo, o meno di 6 celle su 9 >= 1,10, o un vicino < 1,00)")
            R.add("", "- S5 INERZIA: %s" % (("O1 INERTE su %s (delta n < 5 e delta PF < 0,010: casella libera MISURATA, quel file NON conta per S2)" % ", ".join(inert)) if inert else "O1 morde su tutti e tre i file"),
                  "- S2 CENTRO = MEZZO O1 0,20 / O2 %.1f: PF IS **%s** (il PICCO della griglia e' O1 %.2f / O2 %.1f PF %s: si scrive, NON si sceglie); medie di fila 0,10/0,20/0,30 = %s/%s/%s, di colonna = %s/%s/%s; BORDO (fila esterna >= mezzo + 0,08; falso allarme simulato 0,2-8,8%%): %s; celle IS >= 1,10: %d su 9; 4 vicini del mezzo >= 1,00: %s; PF OOS mezzo %s (%s)" % (
                      g["o2"][1], fpf(mz), picco[0], g["o2"][picco[1]], fpf(pfm[picco]), f3(r10), f3(r20), f3(r30), f3(c0), f3(c1), f3(c2), ("SI (%s): l'altopiano sale verso il bordo, si allarga di un passo, nessuna promozione" % ", ".join(bordo)) if bordo else "no", n110, vic_ok, fpf(pfoM), "conferma DEBOLE >= 1,10" if pfoM >= 1.10 else "< 1,10"),
                  "- S1 CAMPIONE: n IS al mezzo %d deal %s 276 (= 150 pos x 1,838)%s; OOS %d deal %s" % (nIS, ">=" if nIS >= DEAL_MERITO else "<", "" if nIS >= DEAL_MERITO else " -> MERITO SOSPESO", nOOS, ">= 276" if nOOS >= DEAL_MERITO else "< 276: merito OOS SOSPESO (atteso su GBPJPY e XAUUSD)"),
                  "- S3 RISCHIO al mezzo (a qualunque n, Emendamento B): DD IS %.2f / DD OOS %.2f a 1%% contro %.1f -> %s; derivato a 2,00 (x1,956-1,990) [DERIVATO]: IS %.2f-%.2f, OOS %.2f-%.2f%s -- OHLC SOTTOSTIMA: sopra boccia, sotto NON dimostra" % (
                      ddI, ddO, MURO_1PCT, "sotto il muro" if (ddI <= MURO_1PCT and ddO <= MURO_1PCT) else "**SOPRA IL MURO: NO PER RISCHIO**", ddI * 1.956, ddI * 1.990, ddO * 1.956, ddO * 1.990, " (sotto 5,03 @1%: starebbe nel muro anche alla taglia FTMO)" if (ddI <= 5.03 and ddO <= 5.03) else ""),
                  "- S4 SEGNI: %s; S6 DEFAULT (proxy O1 0,10 / O2 piu' vicina a 0,35): %s; banda H (classe 178): %s" % (
                      "REGIME" if s4 else "no", " / ".join("O2 %.1f PF IS %s (%s)" % (pv, fpf(pfm[(0.1, g["o2"].index(pv))]), "il centro la batte di >= 0,05" if mz >= pfm[(0.1, g["o2"].index(pv))] + 0.05 else "il centro NON la batte di 0,05: IL DEFAULT VA BENE") for pv in g["prx"]), banda),
                  "- **VERDETTO S8 (per nome): %s**%s%s -- S7: Modello 1 BOCCIA e non PROMUOVE: il massimo e' PASSA LO SCREENING -> serve il tick (2024.07.05 -> 2026.06.30 o storico esterno)" % (
                      ver, " [file con O1 INERTE (S5): %s, il verdetto e' calcolato ANCHE su quel file; la testa dice che NON conta per S2]" % ", ".join(inert) if inert else "",
                      " [G0 %s ROSSO: l'OOS contro il genetico e' NON CONFRONTABILE, l'IS resta leggibile da solo]" % sym if g0lv == 2 else ""))
            n_pos_is = int(round(nIS / 1.838))
            R.add("- Emendamento della finestra: l'IS si misura in operazioni (%d deal ~ %d posizioni [DERIVATO 1,838 deal/pos]); il VECCHIO (IS) giudica il RISCHIO (DD IS %.2f), il RECENTE (OOS) il MERITO (PF OOS %s); rischio: %s" % (
                nIS, n_pos_is, ddI, fpf(pfoM), verdetto_rischio(ddI > MURO_1PCT or ddO > MURO_1PCT, n_pos_is, "DD <= 10,0% @1% in IS e OOS")))
            tab_taglie(max(ddI, ddO), 1.0, R, "Equity DD % max(IS, OOS) al mezzo")
            R.esiti["griglia_" + sym] = ver.split(" (")[0]
            R.esiti["centro_" + sym] = (0.2, g["o2"][1])
            R.esiti["picco_" + sym] = (picco[0], g["o2"][picco[1]])
            # per-trade della cella identificata (OOS)
            for f in files:
                po = f.pt0()
                if po:
                    m = misure_pt(po, f.j["dp"])
                    R.add("- per-trade %s (cella %s=%s, gamba OOS): %s" % (f.j["pid"], f.j["ax"], po.cell, misure_txt(m, po.k)))
                    if f.t == g["f"][1]:
                        R.esiti["pt_pos_" + sym] = m["n"]
            # certificato (CLAUDE.md 09/09) se il centro esce con PF < 1
            R.add("- certificato di morte (09/09): %s" % certificato(True, True, x4.ok, True, True, "PF IS mezzo %s, OOS %s" % (fpf(mz), fpf(pfoM))) if mz < 1.0 or pfoM < 1.0 else
                  "- certificato di morte: non si apre (PF IS mezzo %s, OOS %s non sotto 1,00); gemelli = i 4 simboli + EURUSD di R265, TF = scansione H1 in risultati_archivio/EMA200/H1_OHLC, uscita ad asse = x4" % (fpf(mz), fpf(pfoM)))
    # uscita x4
    if not x4.ok:
        R.add("- USCITA %s: NON VERIFICABILE (%s)" % (g["x4"], "NULLO: " + "; ".join(x4.nullo) if x4.lanciato else "SALTATO"))
    else:
        u = {}
        for tp in (0, 25, 50, 75):
            ri, ro = x4.r("IS", tp), x4.r("OOS", tp)
            if ri and ro:
                u[tp] = (ri, ro)
        if len(u) == 4:
            pfi = {tp: num(u[tp][0]["Profit Factor"]) for tp in u}
            pfo_ = {tp: num(u[tp][1]["Profit Factor"]) for tp in u}
            ddi = {tp: num(u[tp][0]["Equity DD %"]) for tp in u}
            ddo_ = {tp: num(u[tp][1]["Equity DD %"]) for tp in u}
            sp = max(pfi[t] for t in (25, 50, 75)) - min(pfi[t] for t in (25, 50, 75))
            spo = max(pfo_[t] for t in (25, 50, 75)) - min(pfo_[t] for t in (25, 50, 75))
            notizia = pfi[0] >= pfi[50] + 0.05 and pfo_[0] >= pfo_[50] + 0.05 and ddi[0] <= ddi[50] and ddo_[0] <= ddo_[50]
            R.add("- USCITA %s (asse InpTP1Pct sul centro; 0 spegne parziale, BE e trailing: deal = posizioni): IS PF 0/25/50/75 = %s/%s/%s/%s (n %s, DD %s); OOS PF %s/%s/%s/%s (DD %s); 25/50/75 entro 0,03: IS %s, OOS %s; TP1Pct 0 piu' basso e con DD piu' alto del 50 (come sul Dow): IS %s, OOS %s -> **%s**" % (
                g["x4"], fpf(pfi[0]), fpf(pfi[25]), fpf(pfi[50]), fpf(pfi[75]), "/".join(u[t][0]["Trades"] for t in (0, 25, 50, 75)), "/".join("%.2f" % ddi[t] for t in (0, 25, 50, 75)),
                fpf(pfo_[0]), fpf(pfo_[25]), fpf(pfo_[50]), fpf(pfo_[75]), "/".join("%.2f" % ddo_[t] for t in (0, 25, 50, 75)), "si" if sp <= 0.03 else "NO (%.3f)" % sp, "si" if spo <= 0.03 else "NO (%.3f)" % spo,
                "si" if (pfi[0] < pfi[50] and ddi[0] > ddi[50]) else "no", "si" if (pfo_[0] < pfo_[50] and ddo_[0] > ddo_[50]) else "no",
                "NOTIZIA: TP1Pct 0 batte il 50 di >= 0,05 in IS E OOS con DD non peggiore: l'uscita del motore e' SBAGLIATA su %s" % sym if notizia else "l'uscita a parziale/BE/trailing regge (nessuna notizia)"))
            for tp in (0, 25, 75):
                m = m123(u[tp][0], u[tp][1], u[50][0], u[50][1], uscita=True)
                R.add("  - M1-M3 TP1Pct %d contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): %s%s" % (tp, m123_txt(m), " -- calcolato anche sotto 150: INDIZIO, non verdetto" if num(u[tp][1]["Trades"]) < DEAL_MERITO else ""))
            po = x4.pt0()
            if po:
                R.add("  - per-trade %s (cella TP1Pct=%s, OOS): %s" % (x4.j["pid"], po.cell, misure_txt(misure_pt(po, x4.j["dp"]), po.k)))
            R.esiti["uscita_" + sym] = "NOTIZIA" if notizia else "regge"
        else:
            R.add("- USCITA %s: celle mancanti" % g["x4"])
    R.add("")


def gk_of(g):
    return {"GBPJPY": "1", "XAUUSD": "2", "GBPUSD": "3"}[g["sym"]]


def sez_r265b(F, EX, R):
    R.add("## 4. R265b -- WALK-FORWARD EURUSD SOLO CORTO (testa R265 par. 4: griglia a UNA dimensione, O2 0,1..0,4; parte SOLO con K1 di R265a PASS)", "",
          "- regime: %s" % REGIMI["R265b"])
    f = F["R265b"]
    if not f.lanciato:
        R.add("- SALTATO (non lanciato, NON un nullo di catena): %s -> K1 di R265a = %s" % (f.saltato, R.esiti.get("k1_R265a", "n.d.")))
        R.esiti["r265b"] = "SALTATO"
        R.add("")
        return
    if not f.ok:
        R.add("- NON VERIFICABILE (NULLO: %s)" % "; ".join(f.nullo))
        R.esiti["r265b"] = "NULLO"
        R.add("")
        return
    pf5, tr5, dd5, pfo5, tro5, ddo5 = {}, {}, {}, {}, {}, {}
    for o2 in (0.1, 0.2, 0.3, 0.4):
        ri, ro = f.r("IS", o2), f.r("OOS", o2)
        if ri is None or ro is None:
            R.add("- celle mancanti: O2 %.1f" % o2)
            R.esiti["r265b"] = "NV"
            R.add("")
            return
        pf5[o2], tr5[o2], dd5[o2] = num(ri["Profit Factor"]), num(ri["Trades"]), num(ri["Equity DD %"])
        pfo5[o2], tro5[o2], ddo5[o2] = num(ro["Profit Factor"]), num(ro["Trades"]), num(ro["Equity DD %"])
    R.add("| O2 | IS PF / n / DD | OOS PF / n / DD |", "|---|---|---|")
    for o2 in (0.1, 0.2, 0.3, 0.4):
        R.add("| %.1f | %s / %d / %.2f | %s / %d / %.2f |" % (o2, fpf(pf5[o2]), tr5[o2], dd5[o2], fpf(pfo5[o2]), tro5[o2], ddo5[o2]))
    inert = (max(tr5.values()) - min(tr5.values())) < 5 and (max(pf5.values()) - min(pf5.values())) < 0.010
    m02, m03 = min(pf5[0.2], pf5[0.1], pf5[0.3]), min(pf5[0.3], pf5[0.2], pf5[0.4])
    ctr = 0.3 if m03 > m02 else 0.2
    med = (pf5[0.2] + pf5[0.3]) / 2.0
    bordo = [n for c, n in ((pf5[0.1] >= med + 0.08, "O2 0,1"), (pf5[0.4] >= med + 0.08, "O2 0,4")) if c]
    n110 = sum(1 for v in pf5.values() if v >= 1.10)
    vic_ok = pf5[round(ctr - 0.1, 1)] >= 1.00 and pf5[round(ctr + 0.1, 1)] >= 1.00
    mz = pf5[ctr]
    passa = not bordo and mz >= 1.10 and n110 >= 3 and vic_ok
    solido = passa and mz >= 1.27
    nIS, ddI, ddO, pfoM = tr5[ctr], dd5[ctr], ddo5[ctr], pfo5[ctr]
    s4 = mz < 1.00 and pfoM >= 1.10
    banda = "H_EDGE (PF IS >= 1,15 anche con meta' degli anni contro)" if mz >= 1.15 else "H_DERIVA (0,95-1,08: il corto rende per deriva del dollaro)" if 0.95 <= mz <= 1.08 else "ZONA GRIGIA 1,08-1,15: NON CONCLUDENTE" if 1.08 < mz < 1.15 else "FUORI dalle bande (%.3f)" % mz
    ver = ("O2 INERTE (S5): casella libera MISURATA, S2 non si legge" if inert else "BORDO (%s)" % ", ".join(bordo) if bordo else "NO PER RISCHIO (S3)" if (ddI > MURO_1PCT or ddO > MURO_1PCT) else "REGIME, non edge (S4)" if s4
           else "SOSPESO (S1)" if nIS < DEAL_MERITO else "PASSA LO SCREENING, SOLIDO" if solido else "PASSA LO SCREENING" if passa else "NO PER MERITO")
    picco = max(pf5, key=lambda k: pf5[k])
    R.add("", "- S5: delta n %d, delta PF %.3f -> %s; CENTRO (fra 0,2 e 0,3: massimo di min(propria, vicini), a parita' 0,2): O2 %.1f PF IS **%s** (picco a O2 %.1f PF %s: si scrive, NON si sceglie); BORDO (0,1 o 0,4 >= media(0,2 ; 0,3) + 0,08 = %.3f): %s; celle >= 1,10: %d su 4; vicini >= 1,00: %s" % (
        max(tr5.values()) - min(tr5.values()), max(pf5.values()) - min(pf5.values()), "INERTE" if inert else "O2 morde", ctr, fpf(mz), picco, fpf(pf5[picco]), med + 0.08, "SI" if bordo else "no", n110, vic_ok),
          "- S1 n IS centro %d %s 276%s; OOS %d %s" % (nIS, ">=" if nIS >= DEAL_MERITO else "<", "" if nIS >= DEAL_MERITO else " SOSPESO", tro5[ctr], "" if tro5[ctr] >= DEAL_MERITO else "< 276: merito OOS SOSPESO (atteso, testa par. 4: 82-118 posizioni)"),
          "- S3 DD IS %.2f / OOS %.2f a 1%% (derivato a 2,00 [DERIVATO]: %.2f-%.2f / %.2f-%.2f); PF OOS centro %s; S6 proxy del default (O2 0,35 non in griglia: 0,3 e 0,4): PF IS %s / %s -> %s; banda: %s" % (
              ddI, ddO, ddI * 1.956, ddI * 1.990, ddO * 1.956, ddO * 1.990, fpf(pfoM), fpf(pf5[0.3]), fpf(pf5[0.4]), "il centro le batte di >= 0,05" if mz >= max(pf5[0.3], pf5[0.4]) + 0.05 else "IL DEFAULT VA BENE", banda),
          "- **VERDETTO: %s**%s -- Modello 1 boccia e non promuove; rischio: %s" % (ver, " [G0 R265a ROSSO: l'OOS contro la scansione e' NON CONFRONTABILE]" if R.esiti.get("g0_R265a") == "ROSSO" else "", verdetto_rischio(ddI > MURO_1PCT or ddO > MURO_1PCT, int(round(nIS / 1.838)), "DD <= 10,0% @1%")),
          "- anno per anno dell'IS: [NON MISURABILE] (il per-trade dell'IS non sopravvive: resta solo la gamba OOS dell'ultima cella); H_DERIVA/H_EDGE letti sul PF IS al centro.")
    po = f.pt0()
    if po:
        m = misure_pt(po, f.j["dp"])
        R.add("- per-trade 798502 (cella O2=%s, OOS): %s; anno per anno OOS: %s" % (po.cell, misure_txt(m, po.k), anni_pos(po.deals, po.k, ("2024", "2025", "2026"))))
    if mz < 1.0 or pfoM < 1.0:
        R.add("- certificato di morte (09/09): %s" % certificato(True, True, False, True, False, "PF IS centro %s, OOS %s" % (fpf(mz), fpf(pfoM))))
    R.esiti["r265b"] = ver.split(" (")[0]
    R.add("")


# ---------------------------------------------------------------------------
#  R266 -- box asiatico (testa R266a par. 5-8)
# ---------------------------------------------------------------------------
SFASATI = (("2024.12.26", "2025.03.30"), ("2025.10.26", "2026.03.29"))    # R266 par. 3 (orologio BCM)


def sez_r266(F, R):
    R.add("## 5. R266 -- BOX ASIATICO 00:00-07:59 GBPUSD / EURUSD (testa R266a par. 6.3 HN/HE/H0, par. 7 R2/R3/K1/D1, R4 nessuna cella si promuove)", "",
          "- regime dichiarato (Emendamento A/C): %s" % REGIMI["R266"],
          "- il per-trade che sopravvive e' quello della gamba OOS (par. 9): le posizioni IS sono DERIVATE da Trades IS / (deal per posizione dell'OOS).", "")
    pos266 = {}
    for t in ("R266a", "R266b", "R266c", "R266d", "R266e", "R266f"):
        f = F[t]
        lato = {"1": "SOLO LONG", "0": "SOLO SHORT"}.get(f.j["sd"], "DUE LATI")
        if not f.ok:
            R.add("- **%s %s %s: NON VERIFICABILE** (%s)" % (t, f.j["s"], lato, "NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO: " + f.saltato))
            R.esiti["r266_" + t] = "NV"
            continue
        po = f.pt0()
        ri, ro = f.r("IS", f.j["pt"][0]), f.r("OOS", f.j["pt"][0])
        m = misure_pt(po, f.j["dp"])
        nOOS = m["n"]
        kdp = m["kdp"]
        trI = num(ri["Trades"])
        posIS = int(round(trI / kdp)) if kdp and not math.isnan(kdp) and kdp > 0 else -1
        pos266[t] = dict(oos=nOOS, isD=posIS)
        bd = BAND266[t]
        pfI, pfO, ddI, ddO = num(ri["Profit Factor"]), num(ro["Profit Factor"]), num(ri["Equity DD %"]), num(ro["Equity DD %"])
        hyp = ("HN campione insufficiente (posizioni IS %d / OOS %d, pavimento 150): MERITO SOSPESO, il rischio si legge" % (posIS, nOOS) if (posIS < N_MERITO or nOOS < N_MERITO)
               else "HE EDGE (PF IS %s e PF OOS %s >= 1,10 con >= 150 posizioni per finestra) -> il passo dopo e' un round d'altopiano + riprova a tick: FIRMA di Claudio" % (fpf(pfI), fpf(pfO)) if (pfI >= 1.10 and pfO >= 1.10)
               else "H0 piatto / niente (R2 violato: PF IS %s, PF OOS %s, almeno uno < 1,10)" % (fpf(pfI), fpf(pfO)))
        n_ko, lim_min = k1_r266_campione(po.pos(f.j["dp"]), f.j["s"])
        qA, qB, qT = pf_win(po.deals, SFASATI[0][0], SFASATI[0][1], po.k), pf_win(po.deals, SFASATI[1][0], SFASATI[1][1], po.k), pf_win(po.deals, "", "", po.k)
        sgp, sgl = qA["gp"] + qB["gp"], qA["gl"] + qB["gl"]
        agp, agl = qT["gp"] - sgp, qT["gl"] - sgl
        pav, tet = dd_taglia(ddO, 2.0, 1.0)
        r3 = "sotto S3 di R193b (8,0 a 2,00) con la formula lineare" if ddO <= 4.00 else "FUORI da S3 a 2,00 (d > 4,00 lineare%s); OHLC = limite inferiore, il caso migliore" % (" e > 4,08 moltiplicativa" if ddO > 4.08 else "")
        R.add("- **%s %s %s**: IS %s | OOS %s [MISURATO dal CSV]" % (t, f.j["s"], lato, riga_txt(ri), riga_txt(ro)),
              "  - per-trade OOS %s: %s" % (f.j["pt"][0], misure_txt(m, po.k)),
              "  - banda n attesa (posizioni, par. 6.2): IS %d-%d, OOS %d-%d -> IS DERIVATE %d %s, OOS %d %s" % (
                  bd[0], bd[1], bd[2], bd[3], posIS, "SOTTO il limite basso: prima si sospetta lo storico corto (D0), poi le cifre (D1), poi il cancello" if posIS < bd[0] else ("SOPRA la banda" if posIS > bd[1] else "dentro"),
                  nOOS, "SOTTO" if nOOS < bd[2] else ("SOPRA" if nOOS > bd[3] else "dentro")),
              "  - D1 CIFRE: %s" % ("Trades IS %d < 20 -> NON si legge come niente edge: prima Digits/_Point del simbolo" % trI if trI < 20 else "ok (Trades IS %d >= 20)" % trI),
              "  - **R2 MERITO: %s**" % hyp,
              "  - R3 RISCHIO a 1%% (a qualunque n): DD IS %.2f / DD OOS %.2f -> a 2,00 [%.2f ; %.2f] %% [DERIVATO, R193b B3] -> %s; %s" % (ddI, ddO, pav, tet, r3, verdetto_rischio(ddO > 4.08, nOOS, "DD OOS a 1% <= 4,08 (S3 di R193b tradotta)")),
              "  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%%): limite alto dello stop minimo %.2f pip contro cancello %.2f pip, posizioni sotto: %d su %d -> %s" % (
                  lim_min * 10000.0, K1_R266[f.j["s"]] * 10000.0, n_ko, m["n"], "costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)" if n_ko == 0 else "**COSTO NON GARANTITO: il merito non si legge** (prima D1: Digits del simbolo)"),
              "  - R2 anno per anno OOS (posizioni, k tolto): %s" % anni_pos(po.deals, po.k, ("2020", "2021", "2022", "2023", "2024", "2025", "2026")),
              "  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) %d pos PF %s, mesi ALLINEATI %d pos PF %s" % (
                  qA["n"] + qB["n"], fpf(sgp / sgl if sgl > 0 else float("inf")), qT["n"] - qA["n"] - qB["n"], fpf(agp / agl if agl > 0 else float("inf"))))
        tab_taglie(ddO, 1.0, R, "Equity DD % OOS")
        if pfI < 1.0 or pfO < 1.0:
            R.add("  - certificato di morte (09/09): %s -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)" % certificato(True, True, False, True, False, "PF IS %s, OOS %s" % (fpf(pfI), fpf(pfO))))
        R.esiti["r266_" + t] = hyp.split(" ")[0]
    # L0 struttura
    R.add("", "**L0 STRUTTURA per simbolo (par. 6.2: posizioni OOS n_long + n_short >= n_due_lati; se no un pin di lato non e' arrivato)**")
    for ta, tb, tc, sym in (("R266a", "R266b", "R266c", "GBPUSD"), ("R266d", "R266e", "R266f", "EURUSD")):
        if all(t in pos266 for t in (ta, tb, tc)):
            na, nb, nc = pos266[ta]["oos"], pos266[tb]["oos"], pos266[tc]["oos"]
            ko = (nb + nc) < na
            if ko:
                F[tb].nullo.append("L0 STRUTTURA n_long + n_short < n_due_lati")
                F[tc].nullo.append("L0 STRUTTURA n_long + n_short < n_due_lati")
            R.add("- %s: long %d + short %d = %d contro due lati %d -> %s" % (sym, nb, nc, nb + nc, na, "**KO: %s e %s NULLI** (non separabile quale lato)" % (tb, tc) if ko else "ok (OCO: una posizione al giorno)"))
            R.esiti["l0s_" + sym] = "KO" if ko else "ok"
        else:
            R.add("- %s: NON VERIFICABILE (un file del simbolo e' NULLO o SALTATO)" % sym)
    R.add("", "- R4: NESSUNA cella si promuove (sei configurazioni fisse). Se un file esce HE il passo dopo (altopiano buffer/cutoff + riprova a tick) e' una FIRMA di Claudio.", "")


# ---------------------------------------------------------------------------
#  R260d -- oro solo long col trend dell'oro (testa par. 3-4)
# ---------------------------------------------------------------------------
def sez_r260d(F, EX, R):
    R.add("## 6. R260d -- ORO 770402 SOLO LONG COL TREND DELL'ORO (testa R260d par. 3-4: T3, S0, T5, partizione HN/HQ/H0/HG/HR)", "",
          "- regime: %s" % REGIMI["R260"])
    exA, exC = EX["R260a"], EX["R260c"]
    # T5: G0 di R260c esterno
    g0c = 2
    rc = exC.riga(EXT["R260c"]["mg"])
    if rc is not None:
        trV, pfV, prV, ddV = num(rc["Trades"]), num(rc["Profit Factor"]), num(rc["Profit"]), num(rc["Equity DD %"])
        verde = trV == G0_ORO["tr"] and abs(round(pfV, 3) - G0_ORO["pf"]) <= 1e-7 and abs(round(prV, 0) - G0_ORO["pr"]) <= 1e-7 and abs(round(ddV, 2) - G0_ORO["dd"]) <= 1e-7
        giallo = trV == G0_ORO["tr"] and abs(prV - G0_ORO["pr"]) <= G0_ORO["pr"] * 0.01
        g0c = 0 if verde else (1 if giallo else 2)
        R.add("- T5 ORDINE: G0 di R260c (esterno, %s): %s contro R103 693 / 1.308 / 24736 / 5.32 -> **%s**" % (exC.fonte, riga_txt(rc), ["VERDE", "GIALLO", "ROSSO (banco o guardia, NON separati: R260d si scrive ma NON si legge contro R103)"][g0c]))
    else:
        R.add("- T5 ORDINE: G0 di R260c NON VERIFICABILE qui (%s)" % exC.txt)
    R.add("- ancora R260a: %s" % exA.txt)
    R.esiti["g0_R260c"] = ["VERDE", "GIALLO", "ROSSO"][g0c]
    f = F["R260d"]
    if not f.ok:
        R.add("- R260d: NON VERIFICABILE (%s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"), "")
        R.esiti["r260d"] = "NV"
        return
    rd = f.r("OOS", f.j["pt"][0])
    po = f.pt0()
    ra = exA.riga(EXT["R260a"]["mg"])
    if ra is not None:
        t3ko = num(ra["Trades"]) == num(rd["Trades"]) and abs(num(rd["Profit"]) - num(ra["Profit"])) <= EPS
        if t3ko:
            f.nullo.append("T3 FILTRO NON ESEGUITO (identico a R260a)")
        R.add("- T3 FILTRO ESEGUITO? R260d %s contro R260a %s -> %s" % (riga_txt(rd), riga_txt(ra), "**T3 KO: Trades e Profit IDENTICI a R260a = il filtro NON HA MORSO (fail-open di CorrBias) -> cella NON ESEGUITA, R260d NULLO**" if t3ko else "T3 ok: il filtro ha morso (%s)" % "; ".join(cmp4(rd, ra))))
    else:
        R.add("- T3 NON VERIFICABILE finche' non c'e' il CSV di R260a (riga B): %s" % exA.txt)
    if exA.pt is None or exA.cell == "":
        R.add("- S0 e la partizione HN/HQ/H0/HG/HR: NON VERIFICABILI senza il per-trade 795301 di R260a identificato (riga B)")
        R.esiti["r260d"] = "NV_S0"
    elif f.ok:
        pa = exA.pt
        setA = struttura(pa.deals)
        dateA = set(d["t"].date() for d in pa.deals)
        lastD = {}
        for d in po.deals:
            lastD[d["pid"]] = max(lastD.get(d["pid"], d["t"]), d["t"])
        n_match = n_parz = n_ko = 0
        first = ""
        for d in po.deals:
            if (ct(d), d["deal_type"], round(d["price"], 6)) in setA:
                n_match += 1
            elif d["t"].date() in dateA and d["t"] < lastD[d["pid"]]:
                n_parz += 1
            else:
                n_ko += 1
                first = first or ("%s dt %d px %s" % (ct(d), d["deal_type"], d["price"]))
        if n_ko:
            f.nullo.append("S0 SOTTOINSIEME KO")
        R.add("- S0 SOTTOINSIEME (ogni chiusura di R260d in close_time|deal_type|price esiste in R260a): righe %d, trovate %d, parziali ammesse %d, senza gemello %d%s -> %s" % (
            po.n, n_match, n_parz, n_ko, " (prima: %s)" % first if first else "", "**S0 KO: e' cambiato qualcosa oltre al filtro -> R260d NULLO**" if n_ko else "S0 ok"))
        if not n_ko:
            tenA, lastA = {}, {}
            for d in pa.deals:
                if d["pid"] not in lastA or d["t"] > lastA[d["pid"]]:
                    lastA[d["pid"]], tenA[d["pid"]] = d["t"], (ct(d), d["deal_type"], round(d["price"], 6))
            setD = struttura(po.deals)
            ten = [d for d in pa.deals if tenA[d["pid"]] in setD]
            rim = [d for d in pa.deals if tenA[d["pid"]] not in setD]
            qDf, qD1, qD2 = pf_win(po.deals, "", "", po.k), pf_win(po.deals, "", "2023.03.31", po.k), pf_win(po.deals, "2023.04.01", "", po.k)
            qAf, qTen, qRim = pf_win(pa.deals, "", "", pa.k), pf_win(ten, "", "", pa.k), pf_win(rim, "", "", pa.k)
            r2ok = qDf["n"] >= N_MERITO and qDf["pf"] >= 1.10 and qD1["pf"] >= 1.10 and qD2["pf"] >= 1.10
            hyp = ("HN campione sottile (posizioni R260d %d < 150): MERITO SOSPESO, PF tenute/rimosse riportati come INDIZIO senza verdetto" % qDf["n"] if qDf["n"] < N_MERITO
                   else "HQ cancello quasi inerte (posizioni RIMOSSE %d < 50): R260d ~ R260a, cancello forse non acceso (fail-open parziale non escludibile)" % qRim["n"] if qRim["n"] < 50
                   else "H0 niente edge nemmeno col cancello (R2 violato su R260d)" if not r2ok
                   else "HG il trend dell'oro SEPARA (R2 ok, PF rimosse <= 0,90, PF R260d >= PF R260a + 0,10) -- esito che la sonda Oanda NON prevede: si scrive accanto al prior contrario" if (qRim["pf"] <= 0.90 and qDf["pf"] >= qAf["pf"] + 0.10)
                   else "HR il cancello TAGLIA, non separa (R2 ok ma le rimosse non erano peggiori di 0,90, o il guadagno di PF sta sotto 0,10) -- la previsione scritta prima")
            R.add("- PARTIZIONE (posizioni, PF con k tolto): R260d %d pos PF %s (prima meta' < 2023.04.01: %d pos PF %s; seconda: %d pos PF %s) R2 %s | R260a %d pos PF %s = TENUTE %d pos PF %s + RIMOSSE %d pos PF %s (quota tenuta %.3f, stima 0,55-0,75) ==> **%s**" % (
                qDf["n"], fpf(qDf["pf"]), qD1["n"], fpf(qD1["pf"]), qD2["n"], fpf(qD2["pf"]), "rispettato" if r2ok else "VIOLATO", qAf["n"], fpf(qAf["pf"]), qTen["n"], fpf(qTen["pf"]), qRim["n"], fpf(qRim["pf"]), (qTen["n"] / float(qAf["n"]) if qAf["n"] else float("nan")), hyp))
            R.esiti["r260d"] = hyp.split(" ")[0]
            if qDf["pf"] < 1.0:
                R.add("- certificato di morte (09/09): %s" % certificato(True, True, False, True, False, "PF R260d %s" % fpf(qDf["pf"])))
    ddD = num(rd["Equity DD %"])
    m = misure_pt(po, f.j["dp"])
    R.add("- RISCHIO (a qualunque n, Emendamento B): DD R260d a 0,5%% %.2f contro 2,00 (lineare) / 2,06 (moltiplicativa) = S3 di R193b tradotta a 0,5%% -> %s%s; %s" % (
        ddD, "STA SOTTO con tutte e due: l'unico numero che puo' cambiare lo stato della sedia (OHLC = limite inferiore, serve la riprova a tick)" if ddD <= 2.00 else ("sotto solo con la moltiplicativa: serve R193b" if ddD <= 2.06 else "NON sta sotto S3 a 2,00 (a 2,00: %.2f-%.2f %%)" % dd_taglia(ddD, 2.0, 0.5)),
        " [G0 R260c ROSSO o non verificabile: si scrive, NON si legge contro R103]" if g0c == 2 else "", verdetto_rischio(ddD > 2.06, m["n"], "DD a 0,5% <= 2,06")),
          "- per-trade 795304: %s" % misure_txt(m, po.k))
    tab_taglie(ddD, 0.5, R, "Equity DD % a 0,5%")
    R.add("")


# ---------------------------------------------------------------------------
#  R267 -- le manopole a costo zero (R267a par. 0, R267_GENERA.py)
# ---------------------------------------------------------------------------
def part3(pfA, ddA, pfC, ddC, costo=False):
    """LEVA / PEGGIORA(COSTO) / NULLA (R267e/f/g): PF < ancora - 0,05 = PEGGIORA; DD <= 0,85 x ancora e PF >= ancora - 0,05 = LEVA."""
    if pfC < pfA - 0.05:
        return "%s (PF %s < PF ancora %s - 0,05)" % ("COSTO" if costo else "PEGGIORA", fpf(pfC), fpf(pfA))
    if ddC <= 0.85 * ddA and pfC >= pfA - 0.05:
        return "LEVA (DD %.2f <= 0,85 x %.2f e PF >= PF ancora - 0,05)" % (ddC, ddA)
    return "NULLA"


def sottoinsieme(deals, ref_deals, hcut=""):
    """ogni deal (con close_time < hcut se dato) ha un gemello in ref su close_time|deal_type|price; parziali ammesse
    (non ultime della posizione) nelle giornate in cui il riferimento ha lotti <= 0,10 (R267c C2 / R267d V3)."""
    setW = struttura(ref_deals)
    w010 = set(d["t"].date() for d in ref_deals if d["vol"] <= 0.1000001)
    last = {}
    for d in deals:
        last[d["pid"]] = max(last.get(d["pid"], d["t"]), d["t"])
    n = ko = pz = 0
    first = ""
    for d in deals:
        if hcut and d["t"].strftime("%H:%M:%S") >= hcut:
            continue
        n += 1
        if (ct(d), d["deal_type"], round(d["price"], 6)) not in setW:
            if d["t"].date() in w010 and d["t"] < last[d["pid"]]:
                pz += 1
            else:
                ko += 1
                first = first or ct(d)
    return dict(n=n, ko=ko, pz=pz, first=first)


def sez_r267(F, EX, R):
    R.add("## 7. R267 -- LE MANOPOLE A COSTO ZERO (R267a par. 0: magic fisso, per-trade IDENTIFICATO classe 850; R267a NON LANCIATO)", "")
    exC, exW, exR = EX["R260c"], EX["R255a"], EX["R261a"]
    # ---- R267b
    R.add("### 7.1 R267b -- oro 770402, InpMinBoxPts 0/650/1300/1950/2600 (B1-B6; regime %s)" % REGIMI["R260"], "")
    f = F["R267b"]
    if not f.ok:
        R.add("- NON VERIFICABILE (%s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"), "")
        R.esiti["r267b"] = "NV"
    else:
        r0 = f.r("OOS", 0)
        trV, pfV, prV, ddV = num(r0["Trades"]), num(r0["Profit Factor"]), num(r0["Profit"]), num(r0["Equity DD %"])
        verde = trV == G0_ORO["tr"] and abs(round(pfV, 3) - G0_ORO["pf"]) <= 1e-7 and abs(round(prV, 0) - G0_ORO["pr"]) <= 1e-7 and abs(round(ddV, 2) - G0_ORO["dd"]) <= 1e-7
        giallo = trV == G0_ORO["tr"] and abs(prV - G0_ORO["pr"]) <= G0_ORO["pr"] * 0.01
        b1 = 0 if verde else (1 if giallo else 2)
        b1c = ""
        rcx = exC.riga(EXT["R260c"]["mg"])
        if rcx is not None:
            dX = cmp4(r0, rcx)
            b1c = " | cella 0 contro R260c girato (795303, %s): %s" % (exC.fonte, "IDENTICA al centesimo" if not dX else "DIVERSA (%s): banco non deterministico o un pin differisce" % "; ".join(dX))
        trs, pfH, dds = {}, {}, {}
        for sv in f.j["av"]:
            r = f.r("OOS", sv)
            trs[sv], pfH[sv], dds[sv] = num(r["Trades"]), num(r["Profit Factor"]), num(r["Equity DD %"])
        viol = sum(1 for a, b in zip(f.j["av"], f.j["av"][1:]) if trs[b] > trs[a] + 2)
        b3ko = trs[2600] >= trs[0]
        if b3ko:
            f.nullo.append("B3: Trades(2600) non minore di Trades(0): il pin InpMinBoxPts NON e' arrivato")
        passa = {sv: (dds[sv] <= 2.06 and pfH[sv] >= 1.10 and trs[sv] >= 203) for sv in f.j["av"]}
        centri = [f.j["av"][i] for i in (1, 2, 3) if all(passa[f.j["av"][k]] for k in (i - 1, i, i + 1))]
        picco = max(pfH, key=lambda k: pfH[k])
        batte = [sv for sv in f.j["av"][1:] if pfH[sv] >= pfH[0] + 0.10]
        R.add("- B1 G0 in-file: cella 0 %s contro R103 -> **%s**%s" % (riga_txt(r0), ["VERDE", "GIALLO", "ROSSO: le celle si leggono SOLO fra loro, mai contro R103 (cause come R260c R1: guardia, spread in memoria, storico M1)"][b1], b1c),
              "- B3 morde e toglie soltanto: Trades(2600)=%d < Trades(0)=%d %s; crescite oltre 2 deal lungo l'asse: %d%s" % (trs[2600], trs[0], "**NO -> NULLO**" if b3ko else "si", viol, " -> NON LEGGIBILE" if viol else ""),
              "| InpMinBoxPts | Trades | PF | DD a 0,5 (contro 2,06) | DD/DD0 | n/n0 | passa B4+PF+n |", "|---|---|---|---|---|---|---|")
        for sv in f.j["av"]:
            R.add("| %d | %d | %s | %.2f (%s) | %s | %s | %s |" % (sv, trs[sv], fpf(pfH[sv]), dds[sv], "<= 2,06" if dds[sv] <= 2.06 else "> 2,06", f3(dds[sv] / dds[0] if dds[0] > 0 else float("nan")), f3(trs[sv] / trs[0] if trs[0] > 0 else float("nan")), "si" if passa[sv] else "no"))
        R.add("", "- B4: un DD che scende in proporzione a n NON e' una leva (si legge DD/DD0 accanto a n/n0); OHLC = limite inferiore.",
              "- B5 ALTOPIANO, MAI IL PICCO (>= 3 celle contigue con DD <= 2,06, PF >= 1,10, >= 203 deal; CENTRO del tratto): %s; il PICCO di PF sta a %d (%s)%s; celle che battono la cella 0 di >= 0,10: %s" % (
                  "centri possibili %s" % ", ".join(str(c) for c in centri) if centri else "NESSUNO: NON C'E' UNA CONFIGURAZIONE ROBUSTA", picco, fpf(pfH[picco]),
                  " -- NON e' il centro: si scrive e NON si sceglie" if (centri and picco not in centri) else "", ", ".join(str(b) for b in batte) if batte else "nessuna -> IL DEFAULT (filtro spento) VA BENE"))
        for sv in f.j["av"][1:]:
            R.add("  - M1-M2 cella %d contro il CONTROLLO cella 0 dello stesso file (sul CSV; M3 non verificabile: una gamba sola): %s%s" % (sv, m123_txt(m123(None, f.r("OOS", sv), None, r0)), " -- sotto 203 deal: INDIZIO" if trs[sv] < 203 else ""))
        po = f.pt0()
        hg = "H_GIORNO/H_EPOCA NON MISURABILE: per-trade di R267b non identificato"
        if po is not None:
            sN = num(po.cell)
            if exC.pt is None or exC.cell == "":
                hg = "H_GIORNO/H_EPOCA NON MISURABILE senza il per-trade 795303 di R260c identificato (riga B): %s" % exC.txt
            elif sN <= 650:
                hg = "H_GIORNO/H_EPOCA NON MISURABILE: il per-trade sopravvissuto e' della cella S=%s (TOLTE quasi vuote o vuote)" % po.cell
            else:
                pc = exC.pt
                setS = set(ct(d) for d in po.deals)
                lastC = {}
                for d in pc.deals:
                    lastC[d["pid"]] = max(lastC.get(d["pid"], d["t"]), d["t"])
                rT = [d for d in pc.deals if "2024.01.01" <= dstr(d["t"]) <= "2026.06.30" and lastC[d["pid"]].strftime("%Y.%m.%d %H:%M:%S") in setS]
                rX = [d for d in pc.deals if "2024.01.01" <= dstr(d["t"]) <= "2026.06.30" and lastC[d["pid"]].strftime("%Y.%m.%d %H:%M:%S") not in setS]
                qT, qX = pf_win(rT, "", "", pc.k), pf_win(rX, "", "", pc.k)
                hg = "H_GIORNO/H_EPOCA nella finestra 2024.01.01 -> 2026.06.30 del per-trade di R260c (795303, esterno), cella S=%s: TENUTE %d pos PF %s, TOLTE %d pos PF %s -> %s" % (
                    po.cell, qT["n"], fpf(qT["pf"]), qX["n"], fpf(qX["pf"]), "NON MISURABILE (n_tolte < 30)" if qX["n"] < 30 else ("H_GIORNO (il box stretto e' un giorno peggiore anche a parita' d'epoca: leva vera)" if qT["pf"] >= qX["pf"] + 0.30 else ("H_ROVESCIO" if qX["pf"] >= qT["pf"] + 0.30 else "H_EPOCA (|delta| < 0,30: il filtro sceglie l'epoca, la previsione scritta prima)")))
            R.add("- per-trade 796702: cella S=%s -> %s" % (po.cell, misure_txt(misure_pt(po, f.j["dp"]), po.k)))
        R.add("- %s" % hg, "- B6: nessuna cella si promuove (materiale per Claudio, con riprova a tick).", "")
        R.esiti["r267b_centri"] = centri
        R.esiti["r267b_picco"] = picco
        R.esiti["r267b_b1"] = ["VERDE", "GIALLO", "ROSSO"][b1]
    # ---- R267c / R267d (Dow short)
    rowW = exW.riga(EXT["R255a"]["mg"])
    R.add("### 7.2 R267c / R267d -- Dow short (base R255a; C1-C6, V1-V5; regime %s)" % REGIMI["R267dow"], "", "- C1/V1 G0 esterno = R255a: %s" % exW.txt + (" | R255a 793101: %s" % riga_txt(rowW, True) if rowW else ""))
    f = F["R267c"]
    if not f.ok:
        R.add("- R267c: NON VERIFICABILE (%s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
        R.esiti["r267c"] = "NV"
    else:
        r16, r17 = f.r("OOS", 16), f.r("OOS", 17)
        t16, t17 = num(r16["Trades"]), num(r17["Trades"])
        c4 = t16 <= t17 and abs(num(r16["Profit"]) - num(r17["Profit"])) > EPS and (rowW is None or t17 <= num(rowW["Trades"]))
        if not c4:
            f.nullo.append("C4 G2: Trades(16) <= Trades(17) <= Trades(R255a) rovesciato o Profit identico = NON ESEGUITA")
        po = f.pt0()
        c2t, c3t, ptt = "C2 NON VERIFICABILE (per-trade 793101 di R255a non identificato o cella non identificata)", "C3 NON VERIFICABILE", ""
        if po is not None:
            hh = int(num(po.cell))
            late = [d for d in po.deals if d["t"].strftime("%H:%M:%S") > "%02d:00:59" % hh]
            c3t = "C3 orologio morde (cella %d:00): uscite dopo le %d:00:59 = %d%s" % (hh, hh, len(late), " (prima: %s) -> **KO: NON ESEGUITA**" % ct(late[0]) if late else " -> ok")
            if late:
                f.nullo.append("C3 ORARIO DI CHIUSURA NON RISPETTATO")
            if exW.pt is not None and exW.cell != "":
                sw = sottoinsieme(po.deals, exW.pt.deals, "%02d:00:00" % hh)
                c2t = "C2 sottoinsieme (deal con close_time < %d:00:00 con gemello in R255a 793101): %d deal, senza gemello %d, parziali ammesse %d%s -> %s" % (hh, sw["n"], sw["ko"], sw["pz"], " (primo: %s)" % sw["first"] if sw["first"] else "", "ok" if sw["ko"] == 0 else "**ROSSO: NON LEGGIBILE**")
                if sw["ko"]:
                    f.nullo.append("C2 SOTTOINSIEME KO")
            m = misure_pt(po, f.j["dp"])
            ptt = "per-trade 796711 cella %d:00: %s; tetto R2 4,272 a saldo chiuso (curva CONTROLLO) -> DD %.3f %% %s" % (hh, misure_txt(m, po.k), m["dd"], verdetto_rischio(m["dd"] > R2_DOW, m["n"], "DD saldo chiuso <= 4,272"))
        pfW = num(rowW["Profit Factor"]) if rowW else float("nan")
        pc = []
        for h, rq in ((16, r16), (17, r17)):
            pfc = num(rq["Profit Factor"])
            pc.append("cella %d:00 %s -> %s" % (h, riga_txt(rq, True), ("CODA (il pomeriggio restituiva)" if pfc >= pfW + 0.10 else "CORSA (i runner erano il margine)" if pfc <= pfW - 0.10 else "DENTRO: il default 17:30 va bene") if not math.isnan(pfW) else "partizione CODA/CORSA/DENTRO NON VERIFICABILE senza R255a"))
            if rowW is not None:
                pc.append("  M1-M2 cella %d:00 contro il CONTROLLO R255a (esterno, stesso banco): %s -- ~55 posizioni per era: INDIZIO" % (h, m123_txt(m123(None, rq, None, rowW, uscita=True))))
        R.add("- R267c: C4 G2 Trades 16/17/R255a = %d/%d/%s, Profit diversi %s -> %s" % (t16, t17, rowW["Trades"] if rowW else "n.d.", abs(num(r16["Profit"]) - num(r17["Profit"])) > EPS, "ok" if c4 else "**KO -> NON ESEGUITA**"))
        for x in pc:
            R.add("  - " + x)
        R.add("  - %s" % c3t, "  - %s" % c2t, "  - %s" % (ptt or "per-trade 796711 non identificato o ambiguo"),
              "  - C5 rischio: DD e Peggior Giornata per cella contro R255a (sopra, informativo; muro giornaliero FTMO -5,00); n ~55 posizioni per era: MERITO SOSPESO PER ARITMETICA; C6 nessuna cella si promuove; la curva IN FASE NON si ricompone qui (buco dichiarato)")
        R.esiti["r267c"] = "ok" if f.ok else "NULLO"
    f = F["R267d"]
    if not f.ok:
        R.add("- R267d: NON VERIFICABILE (%s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
        R.esiti["r267d"] = "NV"
    else:
        rws = {vm: f.r("OOS", vm) for vm in (0, 0.5, 1, 1.5, 2)}
        trs = {vm: num(r["Trades"]) for vm, r in rws.items()}
        pfH = {vm: num(r["Profit Factor"]) for vm, r in rws.items()}
        dds = {vm: num(r["Equity DD %"]) for vm, r in rws.items()}
        v1 = "V1 NON VERIFICABILE: R255a non su questo PC -> la cella 0,0 vale solo come ancora INTERNA del file"
        if rowW is not None:
            dX = cmp4(rws[0], rowW, True)
            v1 = "V1 G0 in-file: cella 0,0 contro R255a 793101 -> %s" % ("IDENTICA al centesimo" if not dX else "**DIVERSA (%s) -> NULLO**" % "; ".join(dX))
            if dX:
                f.nullo.append("V1 cella 0,0 diversa da R255a")
        viol = sum(1 for a, b in ((0, 0.5), (0.5, 1), (1, 1.5), (1.5, 2)) if trs[b] > trs[a] + 2)
        v2ko = trs[2] >= trs[0]
        if v2ko:
            f.nullo.append("V2: Trades(2,0) non minore di Trades(0,0): il pin InpVolMult NON e' arrivato")
        rr = trs[1.5] / trs[0] if trs[0] > 0 else float("nan")
        hyp = "n.d." if math.isnan(rr) else ("H_R84 (il precedente NASUSD si trasferisce: ammazza-DD)" if 0.25 <= rr <= 0.50 else "H_DILUITO (la media col pre-mercato: il filtro toglie poco)" if rr >= 0.70 else "OLTRE R84 (morde piu' del precedente): nessuna delle due, si scrive il numero" if rr < 0.25 else "fra 0,50 e 0,70: NESSUNA DELLE DUE, si scrive il numero")
        po = f.pt0()
        v3 = "V3 NON VERIFICABILE"
        if po is not None:
            if abs(num(po.cell)) <= EPS:
                v3 = "V3: la cella identificata e' la 0,0 = il confronto sarebbe con R255a stesso, non informa"
            elif exW.pt is not None and exW.cell != "":
                sw = sottoinsieme(po.deals, exW.pt.deals)
                v3 = "V3 sottoinsieme (cella %s contro R255a 793101): %d deal, senza gemello %d, parziali ammesse %d%s -> %s" % (po.cell, sw["n"], sw["ko"], sw["pz"], " (primo: %s)" % sw["first"] if sw["first"] else "", "ok" if sw["ko"] == 0 else "**NON LEGGIBILE**")
                if sw["ko"]:
                    f.nullo.append("V3 SOTTOINSIEME KO")
        batte = [vm for vm in (0.5, 1, 1.5, 2) if pfH[vm] >= pfH[0] + 0.10]
        R.add("- R267d: %s" % v1, "  - V2 morde e toglie soltanto: Trades(2,0)=%d < Trades(0,0)=%d %s, crescite oltre 2 deal: %d" % (trs[2], trs[0], "**NO -> NULLO**" if v2ko else "si", viol),
              "  - r = Trades(1,5)/Trades(0,0) = %s -> **%s**" % (f3(rr), hyp),
              "  | InpVolMult | Trades | PF | DD | Peggior Giornata % | DD/DD0 | n/n0 |", "  |---|---|---|---|---|---|---|")
        for vm in (0, 0.5, 1, 1.5, 2):
            R.add("  | %.1f | %d | %s | %.2f | %s | %s | %s |" % (vm, trs[vm], fpf(pfH[vm]), dds[vm], rws[vm].get("Peggior Giornata %"), f3(dds[vm] / dds[0] if dds[0] > 0 else float("nan")), f3(trs[vm] / trs[0] if trs[0] > 0 else float("nan"))))
        for vm in (0.5, 1, 1.5, 2):
            R.add("  - M1-M2 cella %.1f contro il CONTROLLO cella 0,0 dello stesso file: %s -- ~73 deal: INDIZIO, merito SOSPESO" % (vm, m123_txt(m123(None, rws[vm], None, rws[0]))))
        R.add("  - V4: attesa DD(1,5)/DD(0,0) fra 0,27 e 0,95 sotto H_R84, ~1 sotto H_DILUITO; il tetto R2 4,272 solo sulla cella identificata",
              "  - per-trade 796712: %s" % ("cella %s (attesa 2,0): %s" % (po.cell, misure_txt(misure_pt(po, f.j["dp"]), po.k)) if po else "non identificato o ambiguo"), "  - %s" % v3,
              "  - V5: celle che battono la 0,0 di >= 0,10: %s; PF atteso sotto 1 in tutte le celle; nessuna promozione" % (", ".join("%.1f" % b for b in batte) if batte else "nessuna -> IL DEFAULT (filtro spento) VA BENE"))
        R.esiti["r267d_hyp"] = hyp.split(" ")[0]
    R.add("")
    # ---- R267g (DAX long)
    R.add("### 7.3 R267g1-g4 -- DAX long (base R261a corr=1; U1-U6, D1-D6; regime %s)" % REGIMI["R267dax"], "", "- G0 esterno R261a: %s" % exR.txt)
    rR1, rR0 = exR.riga(1), exR.riga(0)
    datesR = set(d["t"].date() for d in exR.pt.deals) if (exR.pt is not None and exR.cell == "1") else set()
    anc = {}
    for t, v in (("R267g2", 1), ("R267g3", 1), ("R267g4", 50)):
        if F[t].ok:
            anc[t] = F[t].r("IS", v)
    gid = []
    for a, b in (("R267g2", "R267g3"), ("R267g2", "R267g4"), ("R267g3", "R267g4")):
        if a in anc and b in anc:
            dX = cmp4(anc[a], anc[b])
            gid.append("%s == %s: %s" % (a, b, "identiche" if not dX else "DIVERSE (%s) = banco non deterministico o un pin differisce" % "; ".join(dX)))
    R.add("- celle-ancora di g2/g3/g4 identiche fra loro (G interno): %s" % (" | ".join(gid) if gid else "NON VERIFICABILE"))
    for t, man, vals, ancv in (("R267g2", "InpUseTrailing", [0, 1], 1), ("R267g3", "InpBreakeven", [0, 1], 1), ("R267g4", "InpTP1Pct", [0, 25, 50, 75], 50)):
        f = F[t]
        if not f.ok:
            R.add("- %s: NON VERIFICABILE (%s)" % (t, "NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
            continue
        ra = anc[t]
        u1 = "U1 NON VERIFICABILE: %s" % exR.txt
        if rR1 is not None:
            dX = cmp4(ra, rR1)
            u1 = "U1 G0 in-file: cella-ancora %s=%s contro R261a corr=1 (esterno) -> %s" % (man, ancv, "IDENTICA al centesimo" if not dX else "**DIVERSA (%s) -> NULLO**" % "; ".join(dX))
            if dX:
                f.nullo.append("U1 cella-ancora diversa da R261a corr=1")
        pfA, ddA = num(ra["Profit Factor"]), num(ra["Equity DD %"])
        cc, prof = [], {}
        for av in vals:
            rq = f.r("IS", av)
            prof[av] = rq["Profit"]
            pfc, ddc = num(rq["Profit Factor"]), num(rq["Equity DD %"])
            cc.append("%s: %s%s; DD a 1%% %s" % (av, riga_txt(rq), " -> %s; M1-M2 vs ancora: %s" % (part3(pfA, ddA, pfc, ddc), m123_txt(m123(None, rq, None, ra, uscita=True))) if av != ancv else " (ANCORA)", "> 4,08: FUORI da S3 a 2,00 (U5)" if ddc > 4.08 else ("fra 4,00 e 4,08" if ddc > 4.00 else "<= 4,00")))
        if t == "R267g4":
            t0v, t50 = num(f.r("IS", 0)["Trades"]), num(f.r("IS", 50)["Trades"])
            ok2 = t0v < t50 and (prof[25] != prof[50] or prof[50] != prof[75])
            u2 = "U2 morde: Trades(0)=%d < Trades(50)=%d %s, Profit 25/50/75 non identici %s -> %s" % (t0v, t50, "si" if t0v < t50 else "NO", "si" if (prof[25] != prof[50] or prof[50] != prof[75]) else "NO", "ok" if ok2 else "**NON ESEGUITA**")
            if not ok2:
                f.nullo.append("U2 manopola NON ESEGUITA")
        else:
            u2 = "U2 morde: Profit(0) %s contro Profit(1) %s -> %s" % (prof[0], prof[1], "la manopola ha morso" if prof[0] != prof[1] else "IDENTICI: casella INERTE MISURATA (%s), non un difetto" % ("il trailing non ha mai agito sul campione" if t == "R267g2" else "il BE e' coperto dal trailing"))
        po = f.pt0()
        u4 = "U4 NON VERIFICABILE"
        if po is not None and datesR:
            dG = set(d["t"].date() for d in po.deals)
            miss, miss2 = len(dG - datesR), len(datesR - dG)
            u4 = "U4 stessi ingressi (giornate della cella %s contro il per-trade 795401 di R261a corr=1): %d contro %d, solo qui %d, solo in R261a %d -> %s" % (po.cell, len(dG), len(datesR), miss, miss2, "ok" if (miss == 0 and miss2 == 0) else "**DIVERSO -> NON LEGGIBILE**")
            if miss or miss2:
                f.nullo.append("U4 GIORNATE DIVERSE DA R261a")
        elif exR.pt is not None and exR.cell not in ("", "1"):
            u4 = "U4 NON SI FA: il per-trade 795401 di R261a e' della cella corr=%s, non corr=1 (classe 850); il file NON e' nullo" % exR.cell
        R.add("- **%s (%s)**: %s" % (t, man, u1))
        for x in cc:
            R.add("  - " + x)
        R.add("  - %s" % u2, "  - per-trade %s: %s" % (f.j["pid"], ("cella %s: %s" % (po.cell, misure_txt(misure_pt(po, f.j["dp"]), po.k))) if po else "non identificato o ambiguo"), "  - %s" % u4,
              "  - n ~35-63 posizioni: MERITO SOSPESO PER COSTRUZIONE; effetto di lato R151a: BE e trailing spostano anche TP2; U6 nessuna promozione: se nessuna cella batte l'ancora oltre il rumore IL DEFAULT VA BENE = casella (3) riempita")
    f = F["R267g1"]
    if not f.ok:
        R.add("- R267g1: NON VERIFICABILE (%s)" % ("NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
    else:
        tfN = {16388: "H4", 16390: "H6", 16392: "H8", 16396: "H12", 16408: "D1"}
        t0c = num(rR0["Trades"]) if rR0 is not None else float("nan")
        cc, d2ko, d3, pfH = [], 0, [], {}
        for tf in f.j["av"]:
            rq = f.r("IS", tf)
            trc, pfH[tf], ddc = num(rq["Trades"]), num(rq["Profit Factor"]), num(rq["Equity DD %"])
            if not math.isnan(t0c):
                d2ko += trc > t0c + 2
                if trc == t0c:
                    d3.append(tfN[tf])
            cc.append("%s (%d): %s; DD a 1%% %s" % (tfN[tf], tf, riga_txt(rq), "> 4,08 FUORI da S3 a 2,00" if ddc > 4.08 else ("fra 4,00 e 4,08" if ddc > 4.00 else "<= 4,00")))
        if d2ko:
            f.nullo.append("D2: %d celle con Trades > corr=0 + 2" % d2ko)
        h8 = pfH[16392]
        best = run = 0
        for tf in f.j["av"]:
            run = run + 1 if pfH[tf] >= 1.10 else 0
            best = max(best, run)
        hp = ("HP INDIZIO FAVOREVOLE, merito sospeso (PF(H8) >= 1,10 e >= 3 celle contigue >= 1,10)" if (h8 >= 1.10 and best >= 3) else "H0 il filtro non salva il long (PF(H8) < 1,00): la previsione scritta prima" if h8 < 1.00 else "NON C'E' UNA CONFIGURAZIONE ROBUSTA (1,00 <= PF(H8) < 1,10, o H8 >= 1,10 senza 3 contigue)")
        po = f.pt0()
        R.add("- **R267g1 (InpCorrTF H4/H6/H8/H12/D1, classe 287)**: D1 G0 esterno: %s%s" % (exR.txt, " | R261a corr=0: %s" % riga_txt(rR0) if rR0 else ""))
        for x in cc:
            R.add("  - " + x)
        R.add("  - D2 sottoinsieme di struttura (Trades <= corr=0 + 2): %s | D3 morde (celle con Trades IDENTICI a corr=0 = bias tornato 0 = NON ESEGUITA): %s" % (
            "NON VERIFICABILE" if math.isnan(t0c) else ("ok" if d2ko == 0 else "**KO su %d celle -> NULLO**" % d2ko), "NON VERIFICABILE" if math.isnan(t0c) else (", ".join(d3) if d3 else "nessuna")),
              "  - per-trade 796741: %s" % (("cella InpCorrTF=%s%s: %s" % (po.cell, " (D1: guardare il mese del primo deal %s, riscaldamento EMA100 classe 834)" % po.dmin if po.cell == "16408" else "", misure_txt(misure_pt(po, f.j["dp"]), po.k))) if po else "non identificato o ambiguo"),
              "  - partizione sulla cella centrale H8 (MAI il picco): PF %s, celle contigue >= 1,10 al massimo %d -> **%s**; ~55-80 posizioni: MERITO SOSPESO; D6 nessuna promozione" % (fpf(h8), best, hp))
        R.esiti["r267g1"] = hp.split(" ")[0]
        if h8 < 1.0:
            R.add("  - certificato di morte (09/09): %s" % certificato(True, True, True, False, True, "PF(H8) %s" % fpf(h8)))
    R.add("")
    # ---- R267e / R267f (EMA200 GBPJPY/XAUUSD)
    R.add("### 7.4 R267e1/f1/e2/f2 -- EMA200 GBPJPY / XAUUSD, InpUseAdrFilter e InpFridayClose (E1-E5; %s)" % REGIMI["R264OOS"], "")
    for t, bs, man in (("R267e1", "R264c", "InpUseAdrFilter"), ("R267f1", "R264c", "InpFridayClose"), ("R267e2", "R264d", "InpUseAdrFilter"), ("R267f2", "R264d", "InpFridayClose")):
        f = F[t]
        if not f.ok:
            R.add("- %s: NON VERIFICABILE (%s)" % (t, "NULLO: " + "; ".join(f.nullo) if f.lanciato else "SALTATO"))
            continue
        r0, r1 = f.r("OOS", 0), f.r("OOS", 1)
        fb = F[bs]
        e1 = "E1 NON VERIFICABILE (%s NULLO)" % bs
        if fb.ok:
            dX = cmp4(r0, fb.r("OOS", fb.j["pt"][0]))
            e1 = "E1 G0 in-file: cella 0 contro %s (gemella %s, stesso PC, stesso giro) -> %s; contro il genetico: %s" % (bs, fb.j["pt"][0], "IDENTICA al centesimo" if not dX else "**DIVERSA (%s) -> NULLO**" % "; ".join(dX), {"VERDE": "VERDE", "GIALLO": "GIALLO", "ROSSO": "ROSSO -> il file si legge SOLO al suo interno"}.get(R.esiti.get("g0_" + bs), "NV"))
            if dX:
                f.nullo.append("E1 cella 0 diversa da %s" % bs)
        tr0, tr1, pf0, pf1, dd0, dd1 = num(r0["Trades"]), num(r1["Trades"]), num(r0["Profit Factor"]), num(r1["Profit Factor"]), num(r0["Equity DD %"]), num(r1["Equity DD %"])
        morde = abs(num(r0["Profit"]) - num(r1["Profit"])) > EPS
        if man == "InpUseAdrFilter":
            part = "H_INERTE (|dTrades| <= 2% e |dPF| < 0,02): casella MISURATA, manopola INERTE a 0,8 (la manopola che morderebbe e' InpAdrDistMax ~0,5, NON qui)" if (abs(tr1 - tr0) <= 0.02 * tr0 and abs(pf1 - pf0) < 0.02) else "H_MORDE (Trades fuori +-2%% o |dPF| >= 0,02): il rapporto ATR(H4)/ADR 0,41 e' sbagliato o gli shock sono frequenti -> %s" % part3(pf0, dd0, pf1, dd1)
        else:
            part = part3(pf0, dd0, pf1, dd1, costo=True)
        po = f.pt0()
        fri = ""
        if man == "InpFridayClose" and po is not None:
            nF = sum(1 for d in po.deals if d["t"].weekday() == 4 and d["t"].strftime("%H:%M:%S") >= "20:00:00")
            fri = " | chiusure di venerdi' dalle 20:00:00 nel per-trade della cella %s: %d%s" % (po.cell, nF, " (cella 1: attese le chiusure forzate)" if po.cell == "1" else " (cella 0: se 0 e Profit identici, la manopola e' inerte)")
        R.add("- **%s (%s, %s)**: %s" % (t, f.j["s"], man, e1),
              "  - cella 0 %s | cella 1 %s | E2 morde: %s | **%s**%s" % (riga_txt(r0), riga_txt(r1), "Profit diversi, la manopola ha morso" if morde else "Profit IDENTICI: casella INERTE MISURATA (H_INERTE), non un difetto", part, fri),
              "  - M1-M2 cella 1 contro il CONTROLLO cella 0 dello stesso file: %s -- ~100-120 posizioni: INDIZIO, merito SOSPESO" % m123_txt(m123(None, r1, None, r0, uscita=(man == "InpFridayClose"))),
              "  - E3 rischio: DD 0/1 %.2f/%.2f a 1%% contro 10,0 -> %s, derivato a 2,00 x1,956-1,990: %.2f-%.2f%s" % (dd0, dd1, "sotto" if (dd0 <= 10.0 and dd1 <= 10.0) else "**SOPRA il muro**", dd1 * 1.956, dd1 * 1.990, " [ORO a 10000: lotti 0,01-0,03, il DD% NON e' quello a 1% dichiarato; il confronto 1/0 resta valido]" if f.j["s"] == "XAUUSD" else ""),
              "  - per-trade %s: %s" % (f.j["pid"], ("cella %s: %s" % (po.cell, misure_txt(misure_pt(po, f.j["dp"]), po.k))) if po else "non identificato o ambiguo"),
              "  - E4 nessuna promozione (se la cella 1 non batte la 0 oltre il rumore: IL DEFAULT (spento) VA BENE); E5 K1 = quello di %s" % bs)
        R.esiti[t] = part.split(" ")[0]
    R.add("")


# ---------------------------------------------------------------------------
#  Finale: nulli aggiunti in lettura, cosa resta a mano
# ---------------------------------------------------------------------------
def sez_finale(F, R):
    R.add("## 8. Riepilogo dei file, dopo la lettura (i cancelli di lettura -- D0, G2, L0 struttura, T3/S0, B3/V1/V2/V3/C2/C3/C4/U1/U2/U4/D2 -- si aggiungono a quelli del par. 0)", "")
    nulli = [t for t, f in F.items() if f.lanciato and not f.ok]
    salt = [t for t, f in F.items() if not f.lanciato]
    R.add("- FILE NULLI (escono da OGNI conteggio): %s" % (" | ".join("%s (%s)" % (t, "; ".join(F[t].nullo)) for t in nulli) if nulli else "nessuno"),
          "- FILE SALTATI (non lanciati, NON nulli di catena): %s" % (", ".join(salt) if salt else "nessuno"),
          "- FILE NON NULLI, per nome: %s" % (", ".join(t for t, f in F.items() if f.ok) or "NESSUNO"),
          "- R267a: ESCLUSO E DICHIARATO (par. 6-A), non conta ne' fra i nulli ne' fra i saltati.", "",
          "**NESSUNA PROPOSTA DI TAGLIA. Nessuna cella si promuove. Nessun preset, EA, sedia o conto e' toccato.**", "",
          "**Cosa resta a mano (non e' in questo script):** la classe 166 (SHA256 del motore e dell'include dopo ogni job) e gli rc dei job si leggono SOLO dal RIEPILOGO/REFERTO della riga; "
          "il D0 dei log di R266 (riga 'history synchronized' nei giornali dell'agente, LOG_TESTER in UTF-16) resta [NON VERIFICATO] se l'agente non la scrive in ottimizzazione; "
          "lo spread in memoria del terminale (classe 394) NON e' pinnato da questa corsia; la commissione e la griglia H4 di FTMO sono [NON MISURATE]; "
          "ogni decisione su taglie, sedie, R265b dopo un NON RISOLTO, R267a (par. 6-A) e i round d'altopiano dopo un HE/PASSA e' una FIRMA di Claudio.")
    R.esiti["nulli_finali"] = nulli


# ---------------------------------------------------------------------------
#  AUTOTEST -- fixture costruite dagli archivi VERI (ROUND_CORTI_B: 795301/795302/795303 oro, 795401 DAX;
#  R246: 794603/794601 Dow), rimappate sulla finestra del job e sui lotti di LotByRisk, nel layout ESATTO della riga C
# ---------------------------------------------------------------------------
ARC_R246 = os.path.join(QUI, "risultati_archivio", "R246", "PERTRADE")
STAT_COLS = ["Pass", "Profit", "Expected Payoff", "Profit Factor", "Recovery Factor", "Sharpe Ratio", "Equity DD %", "Trades"]
DOW_COLS = ["Peggior Giornata %", "Perdite Consecutive Max", "Serie Perdente Peggiore"]


def _arc(nome, sym="XAUUSD", base=ARCHIVI_REPO):
    return leggi_pertrade(os.path.join(base, "PERTRADE", "abtg_trades_ABTG_MaxMinNotte_%s_%s.csv" % (sym, nome)))


def _pos_src(deals):
    by = OrderedDict()
    for d in sorted(deals, key=lambda x: (x["t"], x["pid"])):
        by.setdefault(d["pid"], []).append(d)
    return list(by.values())


def _remap(pos, d0, d1):
    """rimappa linearmente il primo close di ogni posizione su [d0 ; d1] (ora del giorno conservata), i deal seguono."""
    t0, t1 = datetime.strptime(d0, "%Y.%m.%d") + timedelta(days=1), datetime.strptime(d1, "%Y.%m.%d") - timedelta(days=2)
    a, b = pos[0][0]["t"], pos[-1][0]["t"]
    out = []
    for ds in pos:
        x = (ds[0]["t"] - a).total_seconds() / max(1.0, (b - a).total_seconds())
        nd = t0 + timedelta(days=int(x * (t1 - t0).days))
        delta = nd.replace(hour=ds[0]["t"].hour, minute=ds[0]["t"].minute, second=ds[0]["t"].second) - ds[0]["t"]
        out.append([dict(d, t=d["t"] + delta) for d in ds])
    return out


def _stat(deals, k, dd_eq, dep):
    g = sum(d["net"] for d in deals if d["net"] > 0)
    l = -sum(d["net"] for d in deals if d["net"] <= 0)
    prof = sum(d["net"] for d in deals) - k * sum(d["vol"] for d in deals)
    return dict(Profit="%.2f" % prof, EP="%.5f" % (prof / max(1, len(deals))), PF="%.5f" % (g / l if l > 0 else 99.0), DD="%.4f" % dd_eq, Trades=str(len(deals)),
                Pegg="%.4f" % peggior_giornata(deals, k, dep)["pct"])


def _pf_deals(deals):
    g = sum(d["net"] for d in deals if d["net"] > 0)
    l = -sum(d["net"] for d in deals if d["net"] <= 0)
    return g / l if l > 0 else 99.0


def _tune_pf(deals, target):
    """scala le perdite (bisezione) perche' il PF sui deal cada entro 0,005 dal bersaglio."""
    lo, hi = 0.05, 20.0
    for _ in range(60):
        g = (lo + hi) / 2.0
        pf = _pf_deals([dict(d, net=(d["net"] * g if d["net"] < 0 else d["net"])) for d in deals])
        lo, hi = (g, hi) if pf > target else (lo, g)
    return [dict(d, net=round(d["net"] * hi if d["net"] < 0 else d["net"], 2)) for d in deals]


def ema_pt(src, n_deal, sym, mg, dep, prm, atr, k, price, d0, d1, pf_target, dt_fix=None):
    """per-trade EMA200 FINTO ma STRUTTURALMENTE vero: gamba 1 (pid 10i+1) e gamba 2 (pid 10i+2) come LotByRisk
    (R = saldo x 0,5% per gamba, stop g1 = rat x ATR, stop g2 = ATR, floor 0,01), segni e ampiezze relative dei net
    dalle posizioni REALI dell'archivio, prezzi dell'ordine del simbolo, date rimappate su [d0 ; d1]."""
    pos = _remap(_pos_src(src), d0, d1)
    med = statistics.median(abs(ds[0]["net"] / ds[0]["vol"]) for ds in pos if ds[0]["vol"] > 0)
    out, saldo, i = [], dep, 0
    while len(out) < n_deal:
        ds = pos[i % len(pos)]
        i += 1
        px = price(ds[0]["price"])
        q = (1.0 / px) if prm["q"] == "P" else float(prm["q"])
        R_ = saldo * prm["rf"]
        v2 = max(0.01, math.floor(R_ / (atr * prm["cs"] * q) * 100.0 + 1e-9) / 100.0)
        v1 = max(0.01, math.floor(R_ / (prm["rat"] * atr * prm["cs"] * q) * 100.0 + 1e-9) / 100.0)
        r = (ds[0]["net"] / ds[0]["vol"]) / med
        dt = ds[0]["deal_type"] if dt_fix is None else dt_fix
        t = ds[0]["t"] + timedelta(days=(i // len(pos)) * 3)
        for pid, v in ((10 * i + 1, v1), (10 * i + 2, v2)):
            if len(out) >= n_deal:
                break
            net = round(r * R_ * (0.9 + 0.1 * (pid % 3)), 2)
            out.append(dict(t=t, symbol=sym, magic=int(mg), pid=pid, deal_type=dt, vol=v, price=round(px, 5 if px < 1000 else 2), net=net))
            saldo += net - k * v
    out = _tune_pf(out, pf_target)
    out.sort(key=lambda d: (d["t"], d["pid"]))
    return out


def scrivi_pt(path, deals, mg, sym):
    with open(path, "w", encoding="utf-8", newline="") as fh:
        fh.write("close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n")
        for d in deals:
            fh.write("%s;%s;%s;%d;%d;%.2f;%s;%.2f\n" % (ct(d), sym, mg, d["pid"], d["deal_type"], d["vol"], ("%.5f" % d["price"]) if d["price"] < 1000 else ("%.2f" % d["price"]), d["net"]))


class Fixture:
    def __init__(self, root, variante):
        self.root, self.var = root, variante
        self.saltati = []
        os.makedirs(os.path.join(root, "PERTRADE"), exist_ok=True)
        os.makedirs(os.path.join(root, "ESTERNI"), exist_ok=True)
        os.makedirs(os.path.join(root, "LOG_TESTER"), exist_ok=True)
        self.pins = {}

    def prova(self, t):
        j = JOBS[t] if t in JOBS else R267A
        src = os.path.join(PROVE_REPO, j["p"])
        os.makedirs(os.path.join(self.root, "ROUND_" + t), exist_ok=True)
        import shutil
        shutil.copy(src, os.path.join(self.root, "ROUND_" + t, j["p"]))
        with open(os.path.join(self.root, "ROUND_" + t, "REFERTO_ROUND_%s.txt" % t), "w") as fh:
            fh.write("REFERTO ROUND SUL TERMINALE DA BACKTEST (FIXTURE)\ntetto barre     : MaxBars=100000000\netichetta       : %s\n" % t)
        pin, asse, _ = leggi_pin_prova(src)
        self.pins[t] = pin
        return pin

    def row(self, t, axval, st, dow=False, pin_ko=None):
        pin = self.pins[t]
        r = OrderedDict([("Pass", "0"), ("Profit", st["Profit"]), ("Expected Payoff", st["EP"]), ("Profit Factor", st["PF"]), ("Recovery Factor", "1"), ("Sharpe Ratio", "1"), ("Equity DD %", st["DD"]), ("Trades", st["Trades"])])
        if dow:
            r.update([("Peggior Giornata %", st.get("Pegg", "-0.5")), ("Perdite Consecutive Max", "-100"), ("Serie Perdente Peggiore", "-100")])
        r[JOBS[t]["ax"]] = "%g" % axval
        for n, v in pin.items():
            r[n] = "%g" % (v if n != pin_ko else v + 1)
        return r

    def csv(self, t, leg, rows):
        with open(os.path.join(self.root, "ROUND_" + t, "%s_%s_%s%s_%s.csv" % (JOBS[t]["e"], JOBS[t]["s"], leg, JOBS[t]["sm"], t)), "w", encoding="utf-8", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
            w.writeheader()
            for r in rows:
                w.writerow(r)

    def st(self, pf, n, dd, profit=None, pegg=None):
        return dict(Profit=("%.2f" % profit) if profit is not None else "%.2f" % (n * 3.7 * (pf - 1.0) + 0.01 * n), EP="1", PF="%.5f" % pf, DD="%.4f" % dd, Trades=str(n), Pegg="%.4f" % (pegg if pegg is not None else -0.9))

    def pt(self, t, mg, deals):
        j = JOBS[t] if t in JOBS else EXT[t]
        scrivi_pt(os.path.join(self.root, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (j["e"], j["s"], mg)), deals, mg, j["s"])

    def salta(self, t, motivo):
        self.saltati.append("%s (%s)" % (t, motivo))

    def riepilogo(self):
        with open(os.path.join(self.root, "RIEPILOGO_ROUND_CORTI_C.txt"), "w") as fh:
            fh.write("RIEPILOGO ROUND CORTI C (FIXTURE dell'autotest, variante %s): 37 job\nMETRO TICK EMA200 H4 MISURATO OGGI dal primo job R264c: 6.2 min per file (2 finestre piene + 2 monconi + compilazione) = ~3.10 min per finestra piena\n"
                     "FILE SALTATI (non lanciati, non nulli): %s\n" % (self.var, " | ".join(self.saltati) if self.saltati else "nessuno"))
        with open(os.path.join(self.root, "LOG_TESTER", "0000_fixture_logs.log"), "wb") as fh:
            fh.write("KS\t0\t09:10:57.000\tTester\tXAUUSD: history synchronized from 2019.12.30\n".encode("utf-16"))


def costruisci_fixture(root, variante):
    import shutil
    if os.path.isdir(root):
        shutil.rmtree(root)
    X = Fixture(root, variante)
    arcL, arcS, arcT = _arc("795301"), _arc("795302"), _arc("795303")
    arcD = _arc("795401", "D30EUR")
    dow = leggi_pertrade(os.path.join(ARC_R246, "abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv")) + [dict(d, pid=d["pid"] + 1000) for d in leggi_pertrade(os.path.join(ARC_R246, "abtg_trades_ABTG_Dow_Apertura_US_U30USD_794601.csv"))]
    PX = {"GBPUSD": lambda p: 1.20 + (p % 100) / 1000.0, "EURUSD": lambda p: 1.05 + (p % 100) / 1000.0, "GBPJPY": lambda p: 185.0 + (p % 100) / 10.0, "AUDJPY": lambda p: 95.0 + (p % 100) / 10.0, "XAUUSD": lambda p: p}
    KFX = {"GBPUSD": 2.305, "EURUSD": 2.000, "GBPJPY": 2.310, "AUDJPY": 2.20, "XAUUSD": 1.716}
    ATR = {"R264a": 0.0054, "R264b": 0.90, "R264c": 0.90, "R264d": 15.0, "R265a": (0.0015 if variante == "k1fail" else 0.0045)}
    # ---- G0 (R264c/d/a/b, R265a): gemelle
    g0_rows = {}
    for t in ("R264c", "R264d", "R264a", "R264b", "R265a"):
        j, an = JOBS[t], ANC_G0[t]
        X.prova(t)
        n = an["tr"] + (30 if (variante == "g0rosso" and t == "R264c") else 0)
        deals = ema_pt(arcT, n, j["s"], j["pt"][0], j["dp"], K1PAR[t], ATR[t], KFX[j["s"]], PX[j["s"]], j["d0"], j["d1"], an["pf"], dt_fix=(0 if t == "R265a" else None))
        rows = []
        for mg in j["pt"]:
            X.pt(t, mg, [dict(d, magic=int(mg)) for d in deals])
            rows.append(X.row(t, int(mg), _stat(deals, KFX[j["s"]], an["dd"], j["dp"])))
        X.csv(t, "OOS", rows)
        g0_rows[t] = rows[0]
    # ---- ponte
    t = "R264b1"
    X.prova(t)
    j = JOBS[t]
    d3 = ema_pt(arcT, 286, "AUDJPY", j["pid"], 10000, K1PAR["R264b"], 0.9, KFX["AUDJPY"], PX["AUDJPY"], j["d0"], j["d1"], 1.64)
    X.pt(t, j["pid"], d3)
    X.csv(t, "OOS", [X.row(t, 1.5, X.st(1.71, 276, 2.89)), X.row(t, 2, X.st(1.62, 283, 2.90)), X.row(t, 2.5, X.st(1.60, 280, 2.91)), X.row(t, 3, _stat(d3, KFX["AUDJPY"], 2.92, 10000))])
    # ---- griglie
    GR = {"c": dict(is_pf=[[1.38, 1.22, 1.20], [1.24, 1.20, 1.23], [1.18, 1.19, 1.17]], n_is=420, n_oos=210, dd_is=6.0, oos_pf=1.25),
          "d": dict(is_pf=[[0.98, 0.96, 0.99], [0.97, 0.95, 0.96], [0.94, 0.93, 0.95]], n_is=400, n_oos=150, dd_is=9.0, oos_pf=1.30),
          "a": dict(is_pf=[[1.12, 1.14, 1.10], [1.13, 1.15, 1.12], [1.11, 1.12, 1.10]], n_is=250, n_oos=280, dd_is=7.0, oos_pf=1.20)}
    for gk, g in GRID.items():
        sym, D = g["sym"], GR[gk]
        if variante == "g0rosso" and gk == "c":
            for t in g["f"] + [g["x4"]]:
                X.salta(t, "SALTATO: G0 R264c di GBPJPY ROSSO -> testa R264 par. 10")
            continue
        x2_rows = {}
        for ic, t in enumerate(g["f"]):
            j = JOBS[t]
            X.prova(t)
            ris, roo = [], []
            pt_oos = ema_pt(arcT, D["n_oos"], sym, j["pid"], j["dp"], K1PAR[g["g0"]], ATR[g["g0"]] * 1.2, KFX[sym], PX[sym], j["d0"], j["d1"], D["oos_pf"] + 0.02 * ic)
            X.pt(t, j["pid"], pt_oos)
            for io, o1 in enumerate((0.1, 0.2, 0.3)):
                ris.append(X.row(t, o1, X.st(D["is_pf"][io][ic], D["n_is"] + 2 * io + ic, D["dd_is"] + 0.1 * io)))
                roo.append(X.row(t, o1, _stat(pt_oos, KFX[sym], 4.0 + 0.1 * io, j["dp"]) if o1 == 0.3 else X.st(D["oos_pf"] + 0.01 * io + 0.02 * ic, D["n_oos"] - 3 * io - ic, 4.0 + 0.1 * io)))
            X.csv(t, "IS", ris)
            X.csv(t, "OOS", roo)
            if ic == 1:
                x2_rows = dict(IS=ris[1], OOS=roo[1])
        t = JOBS[g["x4"]]["t"]
        j = JOBS[t]
        X.prova(t)
        pt75 = ema_pt(arcT, D["n_oos"] + 4, sym, j["pid"], j["dp"], K1PAR[g["g0"]], ATR[g["g0"]] * 1.2, KFX[sym], PX[sym], j["d0"], j["d1"], D["oos_pf"] + 0.03)
        X.pt(t, j["pid"], pt75)
        ris, roo = [], []
        for leg, base_row in (("IS", x2_rows["IS"]), ("OOS", x2_rows["OOS"])):
            pf50, n50, dd50 = num(base_row["Profit Factor"]), int(num(base_row["Trades"])), num(base_row["Equity DD %"])
            rows = [X.row(t, 0, X.st(pf50 - 0.08, int(n50 * 0.55), dd50 + 2.0)), X.row(t, 25, X.st(pf50 + 0.01, n50 + 3, dd50 + 0.1)), dict(base_row, InpTP1Pct="50", InpMagic=j["pid"]),
                    (X.row(t, 75, _stat(pt75, KFX[sym], dd50 - 0.1, j["dp"])) if leg == "OOS" else X.row(t, 75, X.st(pf50 - 0.01, n50 + 5, dd50 - 0.1)))]
            X.csv(t, leg, rows)
    # ---- R265b
    t, j = "R265b", JOBS["R265b"]
    if variante == "k1fail":
        X.salta(t, "SALTATO: R265b parte SOLO con K1 di R265a = PASS; qui K1 = FAIL -> EURUSD H4 ESCLUSO PER COSTO")
    else:
        X.prova(t)
        p4 = ema_pt(arcT, 100, "EURUSD", j["pid"], j["dp"], K1PAR["R265a"], 0.005, KFX["EURUSD"], PX["EURUSD"], j["d0"], j["d1"], 1.30, dt_fix=0)
        X.pt(t, j["pid"], p4)
        X.csv(t, "IS", [X.row(t, o2, X.st(pf, 500 + i, 7.0)) for i, (o2, pf) in enumerate(((0.1, 1.02), (0.2, 1.05), (0.3, 1.06), (0.4, 1.00)))])
        X.csv(t, "OOS", [X.row(t, 0.1, X.st(1.25, 96, 4.0)), X.row(t, 0.2, X.st(1.30, 98, 4.1)), X.row(t, 0.3, X.st(1.35, 99, 4.2)), X.row(t, 0.4, _stat(p4, KFX["EURUSD"], 4.3, j["dp"]))])
    # ---- R266
    def box_pt(src, sym, mg, n_max, dt_fix=None, vol=0.30):
        out = []
        for ds in _pos_src(src)[:n_max]:
            d = ds[-1]
            out.append(dict(t=d["t"], symbol=sym, magic=int(mg), pid=d["pid"], deal_type=(d["deal_type"] if dt_fix is None else dt_fix), vol=vol, price=round(PX[sym](d["price"]), 5), net=round(sum(x["net"] for x in ds) / sum(x["vol"] for x in ds) * vol * 0.08, 2)))
        return out
    R266 = {"R266a": (arcT, 9999, None, 1.12, 800), "R266b": (arcL, 9999, 1, 0.95, 400), "R266c": (arcS, 9999, 0, 1.05, 450), "R266d": (arcT, 300, None, 1.15, 500), "R266e": (arcL, 120, 1, 0.90, 200), "R266f": (arcS, 9999, 0, 1.04, 380)}
    for t, (src, nmax, dt, pf_is, n_is) in R266.items():
        j = JOBS[t]
        X.prova(t)
        deals = box_pt(src, j["s"], j["pt"][0], nmax, dt)
        if variante == "latosbagliato" and t == "R266b":
            deals[7]["deal_type"] = 0
        rows_is, rows_oos = [], []
        for mg in j["pt"]:
            X.pt(t, mg, [dict(d, magic=int(mg)) for d in deals])
            rows_is.append(X.row(t, int(mg), X.st(pf_is, n_is, 6.5)))
            rows_oos.append(X.row(t, int(mg), _stat(deals, KFX[j["s"]], 3.9, j["dp"])))
        X.csv(t, "IS", rows_is)
        X.csv(t, "OOS", rows_oos)
    # ---- ESTERNI (R260a, R260c, R261a dal repo; R255a costruito dal Dow R246)
    for nome in ("R260a", "R260c", "R261a"):
        x = EXT[nome]
        shutil.copy(os.path.join(ARCHIVI_REPO, "ROUND_" + nome, "%s_%s_%s%s_%s.csv" % (x["e"], x["s"], x["lg"], x["sm"], nome)), os.path.join(root, "ESTERNI"))
        shutil.copy(os.path.join(ARCHIVI_REPO, "PERTRADE", "abtg_trades_%s_%s_%s.csv" % (x["e"], x["s"], x["mg"])), os.path.join(root, "ESTERNI"))
    w = [dict(d, deal_type=0, vol=round(d["vol"] / 10.0, 2), net=round(d["net"] / 10.0, 2), magic=793101) for d in dow]
    w.sort(key=lambda d: (d["t"], d["pid"]))
    scrivi_pt(os.path.join(root, "ESTERNI", "abtg_trades_ABTG_Dow_Apertura_US_U30USD_793101.csv"), w, "793101", "U30USD")
    X.prova("R267d")
    rowW = X.row("R267d", 0, _stat(w, 0.0, 4.3, 10000), dow=True)
    del rowW["InpVolMult"]
    rowW["InpMagic"] = "793101"
    with open(os.path.join(root, "ESTERNI", "ABTG_Dow_Apertura_US_U30USD_OOS_R255a.csv"), "w", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=list(rowW.keys()))
        wr.writeheader()
        wr.writerow(rowW)
        wr.writerow(dict(rowW, InpMagic="793151"))
    # ---- R260d: sottoinsieme di 795301 (pid % 4 != 0)
    t, j = "R260d", JOBS["R260d"]
    X.prova(t)
    d260 = [dict(d, magic=795304) for d in arcL if d["pid"] % 4 != 0]
    rows = []
    for mg in j["pt"]:
        X.pt(t, mg, [dict(d, magic=int(mg)) for d in d260])
        rows.append(X.row(t, int(mg), _stat(d260, 1.8113, 1.90, j["dp"])))
    X.csv(t, "OOS", rows)
    # ---- R267b: cella 0 = riga vera di R260c; cella 2600 = sottoinsieme di 795303 (pid % 3 == 0)
    t, j = "R267b", JOBS["R267b"]
    X.prova(t)
    rc = leggi_csv(os.path.join(root, "ESTERNI", "ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R260c.csv"))[0]
    d26 = [dict(d, magic=796702) for d in arcT if d["pid"] % 3 == 0]
    X.pt(t, j["pid"], d26)
    r0 = X.row(t, 0, dict(Profit=rc["Profit"], EP=rc["Expected Payoff"], PF=rc["Profit Factor"], DD=rc["Equity DD %"], Trades=rc["Trades"]))
    X.csv(t, "OOS", [r0, X.row(t, 650, X.st(1.15, 520, 1.90)), X.row(t, 1300, X.st(1.20, 330, 1.80)), X.row(t, 1950, X.st(1.35, 250, 1.70)), X.row(t, 2600, _stat(d26, 1.8081, 2.50, j["dp"]))])
    # ---- R267c / R267d
    t, j = "R267c", JOBS["R267c"]
    X.prova(t)
    by = OrderedDict()
    for d in w:
        by.setdefault(d["pid"], []).append(d)
    c17 = []
    for pid, ds in by.items():
        pre = [dict(d, magic=796711) for d in ds if d["t"].strftime("%H:%M:%S") < "17:00:00"]
        post = [d for d in ds if d["t"].strftime("%H:%M:%S") >= "17:00:00"]
        c17 += pre
        if post:
            c17.append(dict(post[0], magic=796711, t=post[0]["t"].replace(hour=17, minute=0, second=0), vol=round(sum(d["vol"] for d in post), 2), net=round(sum(d["net"] for d in post) * 0.8, 2), price=round(post[0]["price"] - 0.5, 2)))
    c17.sort(key=lambda d: (d["t"], d["pid"]))
    X.pt(t, j["pid"], c17)
    X.csv(t, "OOS", [X.row(t, 16, X.st(0.95, len(c17) - 6, 4.9, pegg=-1.2), dow=True), X.row(t, 17, _stat(c17, 0.0, 4.6, 10000), dow=True)])
    t, j = "R267d", JOBS["R267d"]
    days = sorted(set(d["t"].date() for d in w))
    keep = set(days[::3])
    d20 = [dict(d, magic=796712) for d in w if d["t"].date() in keep]
    X.pt(t, j["pid"], d20)
    r00 = X.row(t, 0, _stat(w, 0.0, 4.3, 10000), dow=True)
    X.csv(t, "OOS", [r00, X.row(t, 0.5, X.st(0.93, 180, 4.1), dow=True), X.row(t, 1, X.st(0.94, 150, 3.9), dow=True), X.row(t, 1.5, X.st(0.96, 80, 3.0), dow=True), X.row(t, 2, _stat(d20, 0.0, 2.6, 10000), dow=True)])
    # ---- R267g: ancora = riga vera corr=1 di R261a; per-trade = 795401
    ra = [r for r in leggi_csv(os.path.join(root, "ESTERNI", "ABTG_MaxMinNotte_D30EUR_IS_R261a.csv")) if r["InpUseCorrelation"] == "1"][0]
    anc_st = dict(Profit=ra["Profit"], EP=ra["Expected Payoff"], PF=ra["Profit Factor"], DD=ra["Equity DD %"], Trades=ra["Trades"])
    for t, vals, ancv in (("R267g2", [0, 1], 1), ("R267g3", [0, 1], 1), ("R267g4", [0, 25, 50, 75], 50)):
        j = JOBS[t]
        X.prova(t)
        X.pt(t, j["pid"], [dict(d, magic=int(j["pid"])) for d in arcD])
        rows = []
        for i, v in enumerate(vals):
            rows.append(X.row(t, v, anc_st) if v == ancv else X.row(t, v, X.st(0.85 + 0.01 * i, (90 if v == 0 else 103 + i), 8.0 + 0.2 * i, profit=-4100.0 - 10 * i)))
        X.csv(t, "IS", rows)
    t, j = "R267g1", JOBS["R267g1"]
    X.prova(t)
    daysD = sorted(set(d["t"].date() for d in arcD))
    keep = set(daysD[::2])
    dD1 = [dict(d, magic=796741) for d in arcD if d["t"].date() in keep]
    X.pt(t, j["pid"], dD1)
    X.csv(t, "IS", [X.row(t, 16388, X.st(0.92, 120, 7.0)), X.row(t, 16390, X.st(0.91, 110, 7.1)), X.row(t, 16392, X.st(0.90, 100, 7.2)), X.row(t, 16396, X.st(0.93, 90, 7.3)), X.row(t, 16408, _stat(dD1, 0.0, 7.4, j["dp"]))])
    # ---- R267e/f: cella 0 = riga della gemella del G0; cella 1 disegnata
    for t, bs, kind in (("R267e1", "R264c", "inerte"), ("R267f1", "R264c", "costo"), ("R267e2", "R264d", "leva"), ("R267f2", "R264d", "nulla")):
        j = JOBS[t]
        X.prova(t)
        b = g0_rows[bs]
        pf0, n0, dd0, sym = num(b["Profit Factor"]), int(num(b["Trades"])), num(b["Equity DD %"]), j["s"]
        pf1, n1, dd1 = {"inerte": (pf0 + 0.005, n0 + 1, dd0), "costo": (pf0 - 0.08, n0, dd0 - 0.2), "leva": (pf0 + 0.01, int(n0 * 0.9), dd0 * 0.7), "nulla": (pf0 - 0.01, n0 - 2, dd0 * 0.95)}[kind]
        p1 = ema_pt(arcT, n1, sym, j["pid"], 10000, K1PAR[bs], ATR[bs], KFX[sym], PX[sym], j["d0"], j["d1"], pf1)
        X.pt(t, j["pid"], p1)
        r0 = X.row(t, 0, dict(Profit=b["Profit"], EP=b["Expected Payoff"], PF=b["Profit Factor"], DD=b["Equity DD %"], Trades=b["Trades"]))
        X.csv(t, "OOS", [r0, X.row(t, 1, _stat(p1, KFX[sym], dd1, 10000))])
    if variante == "r267a":
        X.prova("R267a")
    X.riepilogo()
    return root


def autotest(fixture_dir=None):
    ok = True

    def check(cond, msg):
        nonlocal ok
        print(("  ok   " if cond else "  FAIL ") + msg)
        ok = ok and cond
    # ---- (0) CONTRO-ESEMPI sulle formule, numeri rifatti A MANO
    # k della commissione (classe 844) su un archivio VERO: 795301 contro il CSV di R260a: (14255,33 - 14062,14) / 106,66 = 1,8113
    if os.path.isdir(ARCHIVI_REPO):
        d = _arc("795301")
        r = leggi_csv(os.path.join(ARCHIVI_REPO, "ROUND_R260a", "ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R260a.csv"))[0]
        okk, dC, k = k_rule("oro260", sum(x["net"] for x in d), num(r["Profit"]), sum(x["vol"] for x in d), len(d), int(num(r["Trades"])))
        check(okk and abs(k - 1.8113) < 0.0005 and abs(dC - 193.19) < 0.01, "k classe 844 su 795301 vero: (14255,33 - 14062,14)/106,66 = 1,8113 EUR/lotto (misurato %.4f)" % k)
        okd, _, kd = k_rule("usd", -3952.27, -3952.27, 1795.50, 103, 103)
        check(okd and abs(kd) < 1e-9, "795401 corr=1 vero: somma = Profit = -3952,27 -> regola stretta 'usd' ok (k 0), e' la cella corr=1 non la corr=0 (Trades 147)")
        check(not k_rule("usd", -3952.27, -4479.57, 1795.50, 103, 147)[0], "795401 contro la riga corr=0 (Trades 147): righe 103 != 147 -> NON identificata (classe 850)")
    # K1 unita' (classe 846, R264 par. 5): GBPJPY R 50, vol 0,10, q 0,0054147 -> 50/(0,10 x 100000 x 0,0054147) = 0,9234 yen = 92,3 pip; la rovesciata 0,000027
    pos = [dict(pid=1, vol=0.10 / 1.5, saldo=10000.0, px=185.0), dict(pid=2, vol=0.10, saldo=10000.0, px=185.0)]
    ko = k1_lotto(pos, K1PAR["R264c"])
    check(abs(ko["med_hi"] - 0.92341) < 0.0005 and abs(ko["med_lo"] - 50.0 / (0.11 * 100000 * 0.0054147)) < 1e-9 and ko["n_pair"] == 1 and not ko["nullo"],
          "K1 GBPJPY: R 50, vol 0,10, q 0,0054147 -> limite alto 0,9234 yen = 92,3 pip (la rovesciata R q/(vol C) darebbe 0,000027)")
    check(k1_verdetto("R264c", ko, K1PAR["R264c"]) == "SOLO LETTURA", "K1 GBPJPY: soglia 0 -> SOLO LETTURA (spread NON MISURATO)")
    pos = [dict(pid=1, vol=0.10, saldo=10000.0, px=1.08), dict(pid=2, vol=0.18, saldo=10000.0, px=1.08)]
    ko = k1_lotto(pos, K1PAR["R265a"])
    # EURUSD q = 1/1,08: hi2 = 50/(0,18 x 100000 x 0,92593) = 0,0030000 (30,0 pip) >= 26,54; lo2 = 50/(0,19 x 92593) = 0,0028421 >= 26,54 -> PASS
    check(abs(ko["med_hi"] - 0.0030) < 1e-6 and abs(ko["med_lo"] - 0.0028421) < 1e-6 and k1_verdetto("R265a", ko, K1PAR["R265a"]) == "PASS", "K1 EURUSD: vol 0,18 a saldo 10000, P 1,08 -> stop [28,4 ; 30,0] pip >= 26,54 -> PASS")
    pos = [dict(pid=1, vol=0.30, saldo=10000.0, px=1.08), dict(pid=2, vol=0.54, saldo=10000.0, px=1.08)]
    check(k1_verdetto("R265a", k1_lotto(pos, K1PAR["R265a"]), K1PAR["R265a"]) == "FAIL", "K1 EURUSD: vol 0,54 -> limite alto 10,0 pip < 26,54 -> FAIL")
    # R266 K1 a campione (par. 7 K1, controprova della testa): stop 33,7 pip, q 0,86 -> lot 0,34 -> 100/(0,34 x 80000) = 0,003676 >= 0,00337 PASSA; stop 20 pip -> lot 0,58 -> 0,002155 CADE
    lot1 = math.floor(100.0 / (0.00337 * 86000.0) * 100) / 100.0
    lot2 = math.floor(100.0 / (0.0020 * 86000.0) * 100) / 100.0
    n_ko1, lim1 = k1_r266_campione([dict(vol=lot1, saldo=10000.0)], "GBPUSD")
    n_ko2, lim2 = k1_r266_campione([dict(vol=lot2, saldo=10000.0)], "GBPUSD")
    check(lot1 == 0.34 and n_ko1 == 0 and abs(lim1 - 0.0036765) < 1e-6 and lot2 == 0.58 and n_ko2 == 1 and abs(lim2 - 0.0021552) < 1e-6, "R266 K1 campione: lot 0,34 -> 0,003676 PASSA; lot 0,58 -> 0,002155 CADE (controprova della testa par. 7)")
    # peggior giornata: denominatore = saldo a INIZIO giornata. Dep 10000; giorno 1 +100 -> 10100; giorno 2 -202 -> -2,00% (non -2,02% del deposito)
    dd_ = [dict(t=datetime(2025, 1, 6, 10), pid=1, vol=1.0, net=100.0), dict(t=datetime(2025, 1, 7, 10), pid=2, vol=1.0, net=-202.0)]
    pg = peggior_giornata(dd_, 0.0, 10000.0)
    check(abs(pg["pct"] + 2.0) < 1e-9 and pg["data"] == datetime(2025, 1, 7).date(), "peggior giornata: -202 su 10100 a inizio giornata = -2,000%% (sul deposito sarebbe -2,02) -> %.4f" % pg["pct"])
    # DD a saldo chiuso in % del PICCO: 10000 -> 10500 -> 9975: 525/10500 = 5,00% (sul deposito 5,25)
    ch = dd_chiuso([(datetime(2025, 1, 1), 10500.0), (datetime(2025, 1, 2), 9975.0)], 10000.0)
    check(abs(ch["dd"] - 5.0) < 1e-9 and abs(ch["eur"] - 525.0) < 1e-9, "DD chiuso: 10500 -> 9975 = 5,00%% del picco (%.4f), 525 EUR" % ch["dd"])
    # dd_taglia (R260c par. 8): d 2,00 a 0,5 -> 2,00%: lineare 8,00, moltiplicativa 1-(0,98)^4 = 7,76; d 5,32 -> 19,6 / 21,3
    pav, tet = dd_taglia(2.0, 2.0, 0.5)
    pav2, tet2 = dd_taglia(5.32, 2.0, 0.5)
    check(abs(tet - 8.0) < 1e-9 and abs(pav - 7.7632) < 0.001 and abs(pav2 - 19.6) < 0.05 and abs(tet2 - 21.28) < 0.001, "dd_taglia: 2,00 a 0,5 -> [7,76 ; 8,00] a 2,00; 5,32 -> [19,6 ; 21,3] (R260c par. 8)")
    # M1-M3 (leggi_r255 par. 10): cand PF 1,30 EP 10 vs controllo PF 1,15 EP 8 -> M2 passa; PF 1,24 -> fallisce (+0,10 non raggiunto)
    ca, cb, ctl = dict(**{"Profit Factor": "1.30", "Profit": "1000", "Trades": "100", "Equity DD %": "3"}), dict(**{"Profit Factor": "1.24", "Profit": "1000", "Trades": "100", "Equity DD %": "3"}), dict(**{"Profit Factor": "1.15", "Profit": "800", "Trades": "100", "Equity DD %": "3"})
    check(m123(None, ca, None, ctl) == dict(M1=True, M2=True, M3=None) and m123(None, cb, None, ctl)["M2"] is False and m123(ca, ca, ctl, ctl)["M3"] is True, "M1-M3: 1,30 vs 1,15 (+0,10, EP 10 > 8) passa; 1,24 fallisce; M3 solo con due gambe")
    # sottoinsieme con taglio d'ora (R267c C2): il deal delle 17:00 e' escluso dal confronto, quello delle 16:30 deve avere il gemello
    ref = [dict(t=datetime(2025, 1, 6, 16, 30), pid=1, deal_type=0, price=42000.0, vol=0.5)]
    sw = sottoinsieme([dict(t=datetime(2025, 1, 6, 16, 30), pid=1, deal_type=0, price=42000.0, vol=0.5), dict(t=datetime(2025, 1, 6, 17, 0), pid=1, deal_type=0, price=41990.0, vol=0.5)], ref, "17:00:00")
    check(sw["n"] == 1 and sw["ko"] == 0, "sottoinsieme C2: 1 deal prima delle 17:00 con gemello, il flat delle 17:00 escluso")
    check(verdetto_rischio(False, 120, "x").startswith("NON VIOLATO su n = 120") and verdetto_rischio(False, 150, "x").startswith("RISCHIO PASSATO") and verdetto_rischio(True, 500, "x").startswith("VIOLATO"), "classe 804: NON VIOLATO su n = 120, RISCHIO PASSATO a 150, VIOLATO a qualunque n")
    check("NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF)" in certificato(True, True, False, True, False, "x"), "certificato: 2 caselle mancanti -> NON ANCORA MISURATO, non morto")
    # ---- (1) fixture dagli archivi veri
    if not (os.path.isdir(ARCHIVI_REPO) and os.path.isdir(ARC_R246)):
        print("  SKIP archivi CORTI B / R246 non trovati")
        print("AUTOTEST " + ("PASS" if ok else "FAIL"))
        return 0 if ok else 1
    base = fixture_dir or tempfile.mkdtemp(prefix="lettori_c_")
    print("  fixture in %s" % base)
    E = {}
    for var in ("pulito", "g0rosso", "latosbagliato", "k1fail", "r267a"):
        root = costruisci_fixture(os.path.join(base, "ROUND_CORTI_C_" + var), var)
        R = lettura(Raccolta(root))
        with open(os.path.join(root, "REFERTO_LETTURA.md"), "w", encoding="utf-8") as fh:
            fh.write(R.testo())
        E[var] = R.esiti
    P = E["pulito"]
    check(P["n_nulli"] == 0 and P["n_salt"] == 0, "pulito: 37 file NON NULLI, 0 saltati (layout ESATTO della riga: cartelle, suffissi _IS/_OOS/_ohlc, PERTRADE, ESTERNI, RIEPILOGO)")
    check(P["r267a"] == "ESCLUSO_ATTESO", "pulito: R267a assente = ESCLUSO E DICHIARATO, non NULLO")
    check(all(P.get("g0_" + t) == "VERDE" for t in ("R264c", "R264d", "R264a", "R264b", "R265a")), "pulito: 5 G0 VERDI (n, PF entro 0,020, DD entro 5%%): %s" % {t: P.get("g0_" + t) for t in ("R264c", "R264d", "R264a", "R264b", "R265a")})
    check(P.get("k1_R264a") == "PASS" and P.get("k1_R265a") == "PASS" and P.get("k1_R264c") == "SOLO LETTURA" and P.get("k1_R264d") == "NULLO", "pulito: K1 GBPUSD PASS, EURUSD PASS, GBPJPY SOLO LETTURA, oro NULLO (a 10000 le gambe stanno a 0,02/0,03: il floor del lotto rompe il contro-esempio ATR +-12%%, testa par. 11) (%s)" % {t: P.get("k1_" + t) for t in K1PAR})
    check(P.get("ponte") == "CONFERMA", "pulito: ponte AUDJPY CONFERMA (4 celle >= 1,45)")
    check(P.get("griglia_GBPJPY") == "PASSA LO SCREENING" and P.get("centro_GBPJPY") == (0.2, 0.6) and P.get("picco_GBPJPY") == (0.1, 0.5), "pulito: GBPJPY sceglie il CENTRO (0,20/0,6 PF 1,20) e NON il picco (0,10/0,5 PF 1,38): PASSA LO SCREENING")
    check(P.get("griglia_XAUUSD", "").startswith("REGIME"), "pulito: XAUUSD IS 0,95 / OOS 1,30 -> REGIME, non edge (S4)")
    check(P.get("griglia_GBPUSD", "").startswith("SOSPESO"), "pulito: GBPUSD n IS 250 < 276 -> SOSPESO (S1), merito sospeso")
    check(P.get("uscita_GBPJPY") == "regge" and P.get("r265b") == "NO PER MERITO", "pulito: uscita GBPJPY regge; R265b centro 0,2 PF 1,05 -> NO PER MERITO (H_DERIVA)")
    check(P.get("r266_R266e") == "HN" and P.get("r266_R266b") == "H0" and P.get("r266_R266a") == "HE" and P.get("l0s_GBPUSD") == "ok" and P.get("l0s_EURUSD") == "ok", "pulito: R266e 120 posizioni -> HN (SOSPESO), R266b H0, R266a HE; L0 struttura ok (%s)" % {t: P.get("r266_" + t) for t in BAND266})
    check(P.get("g0_R260c") == "VERDE" and P.get("r260d") in ("HR", "HG", "H0", "HN", "HQ"), "pulito: G0 R260c VERDE (riga vera di CORTI B), R260d partizione letta: %s" % P.get("r260d"))
    check(P.get("r267b_b1") == "VERDE" and P.get("r267b_centri") == [1300] and P.get("r267b_picco") == 1950, "pulito: R267b B1 VERDE (cella 0 = R103), altopiano 650-1300-1950 -> centro 1300, il picco 1950 NON e' scelto")
    check(P.get("r267c") == "ok" and P.get("r267d_hyp") == "H_R84", "pulito: R267c C2/C3/C4 ok, R267d r = 80/204 -> H_R84")
    check(P.get("r267g1") == "H0" and P.get("R267e1") == "H_INERTE" and P.get("R267f1") == "COSTO" and P.get("R267e2") == "H_MORDE" and P.get("R267f2") == "NULLA", "pulito: R267g1 H0, e1 H_INERTE, f1 COSTO, e2 H_MORDE, f2 NULLA")
    G = E["g0rosso"]
    check(G.get("g0_R264c") == "ROSSO" and G.get("griglia_GBPJPY") == "NV" and G["n_salt"] == 4, "g0rosso: G0 GBPJPY ROSSO (Trades +30 = +13,6%%) -> c1-c4 SALTATI, griglia NON VERIFICABILE; R267e1/f1 si leggono solo all'interno")
    L = E["latosbagliato"]
    check("R266b" in L.get("nulli_finali", []) and L.get("r266_R266b") == "NV", "latosbagliato: un deal_type 0 nel per-trade solo long di R266b -> L0 -> NULLO")
    K = E["k1fail"]
    check(K.get("k1_R265a") == "FAIL" and K.get("r265b") == "SALTATO", "k1fail: K1 EURUSD FAIL (vol 0,36) -> R265b SALTATO, non nullo di catena")
    check(E["r267a"].get("r267a") == "INATTESO", "r267a: cartella ROUND_R267a presente -> INATTESO, NON LETTO (par. 6-A aperto)")
    print("AUTOTEST " + ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


def main():
    apr = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    apr.add_argument("raccolta", nargs="?", help="cartella ROUND_CORTI_C_<data> estratta dallo zip")
    apr.add_argument("--md", default=None, help="scrive il referto qui (default: stdout)")
    apr.add_argument("--archivi", default=None, help="cartella con gli esterni R260a/R260c/R261a/R255a se non nella raccolta")
    apr.add_argument("--autotest", action="store_true")
    apr.add_argument("--fixture-dir", default=None, help="dove costruire le fixture dell'autotest (default: cartella temporanea)")
    a = apr.parse_args()
    if a.autotest:
        sys.exit(autotest(a.fixture_dir))
    if not a.raccolta or not os.path.isdir(a.raccolta):
        apr.error("serve la cartella della raccolta (o --autotest)")
    R = lettura(Raccolta(a.raccolta, a.archivi))
    if a.md:
        with open(a.md, "w", encoding="utf-8") as fh:
            fh.write(R.testo())
        print("scritto %s (%d righe)" % (a.md, len(R.L)))
    else:
        sys.stdout.write(R.testo())


if __name__ == "__main__":
    main()
