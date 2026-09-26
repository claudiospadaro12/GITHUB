#!/usr/bin/env python3
# =====================================================================
#  R258_GENERA.py -- genera i 20 file prova del round R258
#  (LONDRA ORB ALL'ORA GIUSTA, EA ABTG_Londra_ORB).
#  Scritto il 26/09/2026. ASCII puro. Non lancia niente, non tocca EA,
#  preset o forward: scrive solo backtest_pipeline/prove/R258*.txt.
#  I numeri di costo sono CALCOLATI qui (non a mano) dalle costanti
#  sotto, ognuna con la sua fonte.
# =====================================================================
import os

QUI = os.path.dirname(os.path.abspath(__file__))

# ---------------- costanti con fonte --------------------------------
# spread mediano / P95 ore server 07-12, logger vivo 04-11/09/2026
#   data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv
# commissione MISURATA in pip, giro completo:
#   backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md r.70-73
COSTO = {
    "GBPUSD": dict(spr=0.300, p95=0.700, comm=0.540),
    "EURUSD": dict(spr=0.200, p95=0.400, comm=0.464),
}
FERIALI = dict(T=(207, 311), F=(150, 110), G=(207, 311), L=(2153, 2154), B=(207, 311), D=(207, 311))
FGRID = [0, 10, 20, 30, 40, 50, 60, 70]
BGRID = [1, 3, 5]

def allin(s):
    c = COSTO[s]
    return c["spr"] + c["comm"], c["p95"] + c["comm"]

def banda(r):
    if r >= 40.0:
        return "AMMESSA"
    if r >= 13.3:
        return "FRAGILE"
    return "ESCLUSA"

def tabella_costo(s):
    c, c95 = allin(s)
    r = []
    V = lambda t: t.replace(".", ",")
    r.append(V("#   %s: costo all-in mediano c = %.3f + %.3f = %.3f pip"
             % (s, COSTO[s]["spr"], COSTO[s]["comm"], c)))
    r.append(V("#           (P95: %.3f + %.3f = %.3f pip)" % (COSTO[s]["p95"], COSTO[s]["comm"], c95)))
    r.append(V("#     40x  -> stop >= %.2f pip ; 13,3x -> stop >= %.2f pip" % (40 * c, 13.3 * c)))
    for b in BGRID:
        r.append(V("#     b=%d: W mediano serve >= %.1f pip per il 40x, >= %.1f per il 13,3x"
                 % (b, 2 * (40 * c - b), 2 * (13.3 * c - b))))
    r.append("#     stop MINIMO per costruzione = F/2 + b (x = stop / c). La banda qui e'")
    r.append("#     solo il LIMITE INFERIORE garantito dal pavimento; il verdetto K1 si")
    r.append("#     legge sullo stop MEDIANO (F*, par. 7). Righe designate: F=70 b=3")
    r.append("#     GBPUSD e F=50 b=3 EURUSD, le prime AMMESSE a b=3.")
    r.append("#       F  |  b=1           |  b=3           |  b=5")
    for f in FGRID:
        cel = []
        for b in BGRID:
            st = f / 2.0 + b
            x = st / c
            cel.append(("%5.1f %5.1fx %-7s" % (st, x, banda(x) if f > 0 else "n/m")).replace(".", ","))
        r.append(("#      %2d  | %s" % (f, " | ".join(cel))).rstrip())
    r.append("#     (n/m = F=0: lo stop minimo non dice niente, vale il MEDIANO, par. 7 K1)")
    return r

# ---------------- pin comuni ----------------------------------------
def pin(h, s, magic_riga, buf_riga, f_riga, startmin_riga, commento):
    return [
        "InpRangeStartHour=%d||%d||0||%d||N" % (h - 1, h - 1, h - 1),
        startmin_riga,
        "InpRangeEndHour=%d||%d||0||%d||N" % (h, h, h),
        "InpRangeEndMin=0||0||0||0||N",
        f_riga,
        "InpMaxRangePips=0||0||0||0||N",
        "InpPlaceHour=%d||%d||0||%d||N" % (h, h, h),
        "InpPlaceMin=0||0||0||0||N",
        "InpEntryCutoffHour=%d||%d||0||%d||N" % (h + 4, h + 4, h + 4),
        "InpEntryCutoffMin=0||0||0||0||N",
        "InpCloseHour=%d||%d||0||%d||N" % (h + 9, h + 9, h + 9),
        "InpCloseMin=0||0||0||0||N",
        "InpCloseAtEnd=1||1||0||1||N",
        "InpOneTradePerDay=1||1||0||1||N",
        "InpPendingExpiryMin=240||240||0||240||N",
        buf_riga,
        "InpAllowLong=1||1||0||1||N",
        "InpAllowShort=1||1||0||1||N",
        "InpSLMode=0||0||0||0||N",
        "InpHalveOnOpposite=0||0||0||0||N",
        "InpTPRangeMult=1.0||1.0||0||1.0||N",
        "InpUsePartial=0||0||0||0||N",
        "InpTP1_R=1.0||1.0||0||1.0||N",
        "InpTP1Pct=50||50||0||50||N",
        "InpBreakeven=0||0||0||0||N",
        "InpUseTrailing=0||0||0||0||N",
        "InpTrailTF=15||15||0||15||N",
        "InpAtrPeriod=14||14||0||14||N",
        "InpTrailAtrMult=2.0||2.0||0||2.0||N",
        "InpRiskPercent=1.0||1.0||0||1.0||N",
        "InpUseNewsFilter=0||0||0||0||N",
        "InpNewsFile=abtg_news.csv",
        "InpNewsMinImpact=3||3||0||3||N",
        "InpNewsBeforeMin=60||60||0||60||N",
        "InpNewsAfterMin=60||60||0||60||N",
        "InpNewsShiftMinutes=0||0||0||0||N",
        "InpNewsCurrencies=GBP,USD",
        "InpComment=" + commento,
        magic_riga,
        "InpMaxSpread=0||0||0||0||N",
        "InpVerbose=1||1||0||1||N",
    ]

F_ASSE = "InpMinRangePips=0||0||10||70||Y"
F_ZERO = "InpMinRangePips=0||0||0||0||N"
B_ASSE = "InpBufferPips=3.0||1.0||2.0||5.0||Y"
B_TRE = "InpBufferPips=3.0||3.0||0||3.0||N"
SM_ZERO = "InpRangeStartMin=0||0||0||0||N"
SM_ASSE = "InpRangeStartMin=0||0||30||30||Y"

def magic_pin(m):
    return "InpMagic=%d||%d||0||%d||N" % (m, m, m)

RUOLO_ORA = {
    7: "ora 7 = canale 06-07, ordini 07 server: la convenzione del PDF d'estate e nel vecchio orologio; Londra -2h negli inverni dal 2025",
    8: "ora 8 = canale 07-08, ordini 08 server: apertura di Londra d'estate e nel vecchio orologio; la convenzione del PDF negli inverni dal 2025",
    9: "ora 9 = canale 08-09, ordini 09 server: Londra +1h d'estate e nel vecchio orologio; apertura di Londra negli inverni dal 2025",
}

# ---------------- elenco dei file -----------------------------------
# (lettera, blocco, simbolo, ora, magic, nome)
FILES = [
    ("a", "T", "GBPUSD", 8, 795808, "R258a_londra_T_GBPUSD_ora8_UK_TESTA.txt"),
    ("b", "T", "GBPUSD", 7, 795807, "R258b_londra_T_GBPUSD_ora7_PDF.txt"),
    ("c", "T", "GBPUSD", 9, 795809, "R258c_londra_T_GBPUSD_ora9.txt"),
    ("d", "T", "EURUSD", 8, 795818, "R258d_londra_T_EURUSD_ora8_UK.txt"),
    ("e", "T", "EURUSD", 7, 795817, "R258e_londra_T_EURUSD_ora7_PDF.txt"),
    ("f", "T", "EURUSD", 9, 795819, "R258f_londra_T_EURUSD_ora9.txt"),
    ("g", "G", "GBPUSD", 8, 795840, "R258g_londra_G_GBPUSD_M30_gemelle.txt"),
    ("h", "G", "EURUSD", 8, 795841, "R258h_londra_G_EURUSD_M30_gemelle.txt"),
    ("i", "F", "GBPUSD", 7, 795827, "R258i_londra_F_GBPUSD_ora7_stagioni.txt"),
    ("j", "F", "GBPUSD", 8, 795828, "R258j_londra_F_GBPUSD_ora8_stagioni.txt"),
    ("k", "F", "GBPUSD", 9, 795829, "R258k_londra_F_GBPUSD_ora9_stagioni.txt"),
    ("l", "F", "EURUSD", 7, 795837, "R258l_londra_F_EURUSD_ora7_stagioni.txt"),
    ("m", "F", "EURUSD", 8, 795838, "R258m_londra_F_EURUSD_ora8_stagioni.txt"),
    ("n", "F", "EURUSD", 9, 795839, "R258n_londra_F_EURUSD_ora9_stagioni.txt"),
    ("o", "L", "GBPUSD", 7, 795847, "R258o_londra_L_GBPUSD_ora7_OHLC_screening.txt"),
    ("p", "L", "GBPUSD", 8, 795848, "R258p_londra_L_GBPUSD_ora8_OHLC_screening.txt"),
    ("q", "L", "GBPUSD", 9, 795849, "R258q_londra_L_GBPUSD_ora9_OHLC_screening.txt"),
    ("r", "L", "EURUSD", 7, 795857, "R258r_londra_L_EURUSD_ora7_OHLC_screening.txt"),
    ("s", "L", "EURUSD", 8, 795858, "R258s_londra_L_EURUSD_ora8_OHLC_screening.txt"),
    ("t", "L", "EURUSD", 9, 795859, "R258t_londra_L_EURUSD_ora9_OHLC_screening.txt"),
    ("u", "B", "GBPUSD", 8, 795860, "R258u_londra_B_GBPUSD_ora8_buffer_F70.txt"),
    ("v", "B", "EURUSD", 8, 795861, "R258v_londra_B_EURUSD_ora8_buffer_F50.txt"),
    ("w", "D", "GBPUSD", 8, 795870, "R258w_londra_D_GBPUSD_ora8_durata.txt"),
    ("x", "D", "EURUSD", 8, 795871, "R258x_londra_D_EURUSD_ora8_durata.txt"),
]
FDESIGNATO = {"GBPUSD": 70, "EURUSD": 50}

DIRETTIVE = {
    "T": ("M5", "2024.07.05", "2026.06.30", "0.40"),
    "G": ("M30", "2024.07.05", "2026.06.30", "0.40"),
    "F": ("M5", "2025.03.31", "2026.03.27", "0.5748"),
    "L": ("H4", "2008.01.02", "2024.07.04", "0.50"),
    "B": ("M5", "2024.07.05", "2026.06.30", "0.40"),
    "D": ("M5", "2024.07.05", "2026.06.30", "0.40"),
}
FINESTRE = {
    "T": "IS 2024.07.05..2025.04.21 (207 feriali) / OOS 2025.04.22..2026.06.30 (311 feriali)",
    "G": "IS 2024.07.05..2025.04.21 (207 feriali) / OOS 2025.04.22..2026.06.30 (311 feriali)",
    "F": "IS 2025.03.31..2025.10.24 = ESTATE (150 feriali) / OOS 2025.10.25..2026.03.27 = INVERNO (110 feriali)",
    "L": "IS 2008.01.02..2016.04.03 (2153 feriali) / OOS 2016.04.04..2024.07.04 (2154 feriali)",
    "B": "IS 2024.07.05..2025.04.21 (207 feriali) / OOS 2025.04.22..2026.06.30 (311 feriali)",
    "D": "IS 2024.07.05..2025.04.21 (207 feriali) / OOS 2025.04.22..2026.06.30 (311 feriali)",
}
MODELLO = {"T": "-Modello 4 (tick reali)", "G": "-Modello 4 (tick reali)",
           "F": "-Modello 4 (tick reali)", "L": "-Modello 1 (OHLC M1): SOLO SCREENING",
           "B": "-Modello 4 (tick reali)", "D": "-Modello 4 (tick reali)"}
CELLE = {"T": 8, "G": 2, "F": 8, "L": 8, "B": 3, "D": 2}

BANCO = [
    "#  GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. MAI SUL VPS (firma di",
    "#  Claudio del 21/09/2026: sul VPS operano le sedie della challenge).",
    "#  Prima si controlla che il terminale del PC non abbia sedie attaccate.",
    "#  VINCOLI DI BANCO (stanno nella riga di lancio, classe 692):",
    "#    -Deposito 10000 (rischio di banco InpRiskPercent=1.0, pinnato qui)",
    "#    %s",
    "#    NIENTE -Spread, NIENTE -Ritardo, NIENTE -FrazioneIS (il taglio lo da'",
    "#    '@FRAZIONEIS' qui sotto; un -FrazioneIS diverso fa morire il driver),",
    "#    MaxBars=100000000 come in R246/R251/R252/R253.",
    "#  QUESTO FILE NON CONTIENE E NON AUTORIZZA NESSUNA RIGA DI LANCIO. Non",
    "#  tocca EA, preset, sedie, conti, taglie o parametri del forward. Non",
    "#  promuove niente in campo: ogni esito e' materiale per Claudio.",
]

def testa_breve(lett, blocco, s, h, m, nome):
    tipo = {"T": "BLOCCO T -- ORA FISSA, TICK REALI, finestra tick intera",
            "G": "BLOCCO G -- GEMELLE (G1) + TF INERTE (T1), grafico M30",
            "B": "BLOCCO B -- ALTOPIANO DEL BUFFER sulla riga DESIGNATA (M4)",
            "D": "BLOCCO D -- DURATA DEL CANALE 60'/30' (certificato p.5)",
            "F": "BLOCCO F -- ORA FISSA SU GAMBE STAGIONALI (curva IN FASE per gambe)",
            "L": "BLOCCO L -- SCREENING OHLC M1 2008-2024 (vecchio orologio)"}[blocco]
    r = []
    r.append("# =====================================================================")
    r.append("#  R258%s -- LONDRA ORB ALL'ORA GIUSTA -- %s" % (lett, tipo))
    r.append("#  EA: ABTG_Londra_ORB   (%s)   simbolo %s" % (DIRETTIVE[blocco][0], s))
    if blocco in ("G", "B", "D"):
        r.append("#  ora 8 fissa: %s" % RUOLO_ORA[8])
    else:
        r.append("#  %s" % RUOLO_ORA[h])
    r.append("#  Scritto il 26/09/2026. CRITERI: quelli di R258a par. 7, CONGELATI PRIMA")
    r.append("#  DEI NUMERI e validi per TUTTI i file R258. Qui solo cio' che e' proprio")
    r.append("#  di questo file. Sorgente dell'EA: mql5/Experts/ABTG_Londra_ORB.mq5")
    r.append("#  (490 righe, ultimo commit 3af47ed9), NON la copia standalone/.")
    r.append("# =====================================================================")
    r += [x if "%s" not in x else x % MODELLO[blocco] for x in BANCO]
    r.append("#")
    r.append("#  FINESTRA: %s" % FINESTRE[blocco])
    r.append("#  CELLE %d x 2 gambe = %d passate." % (CELLE[blocco], 2 * CELLE[blocco]))
    return r

def corpo_blocco(lett, blocco, s, h, m):
    r = []
    if blocco == "T":
        r += [
            "#",
            "#  ASSE UNICO: InpMinRangePips 0..70 passo 10 (8 righe: la SCANSIONE DEL",
            "#  CANALE, che misura la distribuzione di W e il cancello del costo,",
            "#  R258a par. 6-7). InpBufferPips = 3 fisso (il PDF). L'altopiano del",
            "#  buffer (M4) sta nei file B (u, v).",
            "#  Magic %d fisso (vergine: grep su disco e su 23 ref git, 26/09)." % m,
            "#  Cutoff = ora+4 (identita' cutoff == scadenza 240', R216a par. 2-bis),",
            "#  chiusura = ora+9 = %d:00 server (prima del rollover delle 22)." % (h + 9),
        ]
        if (s, h) == ("GBPUSD", 7):
            r += ["#  >>> RIGA ANCORA 'FEDELE AL PDF': b=3, F=0 (buffer 3 pip, SL al centro,",
                  "#      TP = ingresso +/- W). Deviazioni dal PDF: R258a par. 2."]
        if (s, h) == ("EURUSD", 8):
            r += ["#  >>> RIGA DESIGNATA EURUSD (unica promuovibile): F=50 (R258a par. 7)."]
        if s == "EURUSD":
            r += ["#  EURUSD e' il GEMELLO (certificato p.4): il PDF nomina solo GBPUSD.",
                  "#  InpNewsCurrencies resta il default 'GBP,USD': INERTE (filtro spento)."]
        r += ["#", "#  IL COSTO DI QUESTO SIMBOLO (R258a par. 7 K1), calcolato:"]
        r += tabella_costo(s)
    elif blocco == "G":
        r += [
            "#",
            "#  ASSE UNICO: InpMagic %d / %d (gemelle, G1). Pin: ora 8, b=3, F=0," % (m, m + 50),
            "#  canale 60'. GRAFICO M30 APPOSTA: le due righe devono essere IDENTICHE",
            "#  alla riga F=0 di %s (grafico M5) -> T1." %
            ("R258a" if s == "GBPUSD" else "R258d"),
            "#  Contro-esempio che T1 vede: se il tester non servisse le M1 all'EA su un",
            "#  grafico M30 (o il tetto delle barre le tagliasse), ComputeRange (r.174-",
            "#  185) fallirebbe o leggerebbe un altro canale: Trades diversi -> NULLO.",
            "#  Il blocco T gira su M5 e questo su M30: se il TF fosse davvero inerte",
            "#  (r.174-184 PERIOD_M1 cablato, OnTick a ogni tick) i numeri coincidono al",
            "#  centesimo.",
        ]
    elif blocco == "F":
        r += [
            "#",
            "#  PERCHE' ESISTE: l'EA non scrive un per-trade (R258a par. 3 D1), quindi la",
            "#  curva IN FASE non si ricompone riga per riga come in R252/R255. Qui la",
            "#  si ricompone per GAMBE: '@FRAZIONEIS 0.5748' su 361 giorni da' Meta =",
            "#  2025.03.31 + floor(207,5) = 2025.10.24 (driver r.934, verificato col",
            "#  calcolo): IS = estate 2025 intera, OOS = inverno 2025/26 intero. Il cambio",
            "#  d'ora europeo e britannico e' la notte del 26/10/2025.",
            "#  In questo file, ora %d:" % h,
        ]
        if h == 7:
            r += ["#    gamba ESTATE  = PDF IN FASE (Londra -1h)",
                  "#    gamba INVERNO = Londra -2h (fuori fase per tutti)"]
        elif h == 8:
            r += ["#    gamba ESTATE  = LONDRA IN FASE",
                  "#    gamba INVERNO = PDF IN FASE (Londra -1h)"]
        else:
            r += ["#    gamba ESTATE  = Londra +1h",
                  "#    gamba INVERNO = LONDRA IN FASE"]
        r += [
            "#  ASSE: InpMinRangePips 0..70 passo 10 (8), b=3 fisso. Magic %d." % m,
            "#  Il merito e' SOSPESO per aritmetica in ogni gamba (<= 150 e <= 110",
            "#  feriali): si legge solo H2 (R258a par. 7) e il rischio R1.",
        ]
    elif blocco == "B":
        fd = FDESIGNATO[s]
        c, _ = allin(s)
        r += [
            "#",
            "#  ASSE UNICO: InpBufferPips 1 / 3 / 5 sulla riga DESIGNATA di %s:" % s,
            "#  ora 8, F=%d (R258a par. 7). Serve SOLO a M4 (altopiano, mai il picco):" % fd,
            "#  la riga b=3 promuove solo se anche b=1 e b=5 passano R1 e M1.",
            "#  CONTROLLO INCROCIATO X1: la riga b=3 di questo file = la riga F=%d di" % fd,
            "#  %s al centesimo (stessi pin di trading, cambiano magic e commento)." %
            ("R258a" if s == "GBPUSD" else "R258d"),
            ("#  Stop minimo per costruzione (F/2 + b) sulle tre righe: %.1f / %.1f / %.1f"
             " pip = %.1fx / %.1fx / %.1fx all-in" % (fd / 2 + 1, fd / 2 + 3, fd / 2 + 5,
             (fd / 2 + 1) / c, (fd / 2 + 3) / c, (fd / 2 + 5) / c)).replace(".", ","),
            "#  Magic %d (vergine, grep del 26/09)." % m,
        ]
    elif blocco == "D":
        r += [
            "#",
            "#  ASSE UNICO: InpRangeStartMin 0 / 30 = canale di 60' (il PDF) oppure di",
            "#  30' (07:30-08:00). E' la manopola EQUIVALENTE AL TF per questo EA",
            "#  (certificato p.5): il TF del grafico e' inerte (T1), la durata del",
            "#  canale no. Pin: ora 8, b=3, F=0. Il canale di 30' e' una DEVIAZIONE dal",
            "#  PDF, dichiarata.",
            "#  CONTROLLO INCROCIATO X1: la riga StartMin=0 = la riga F=0 di %s al" %
            ("R258a" if s == "GBPUSD" else "R258d"),
            "#  centesimo. Si legge: n, PF, DD_fisso della riga 30' contro quella 60';",
            "#  il merito solo col cancello di R258a par. 7 (e il costo con un canale",
            "#  piu' stretto e' atteso PEGGIORE: stop = W/2 + 3 con W piu' piccolo).",
            "#  Magic %d (vergine, grep del 26/09)." % m,
        ]
    else:  # L
        r += [
            "#",
            "#  SCREENING, MAI UN VERDETTO DI MERITO. Modello 1 (OHLC M1): i tick prima del",
            "#  2024.07.05 NON sono reali (NOTA_PAVIMENTO_TICK_FOREX_2026-09-01), e sulla",
            "#  famiglia breakout l'OHLC ha gonfiato il PF del 71-125% (REGISTRO_TEST r.112).",
            "#  COSA INVECE E' AFFIDABILE ANCHE QUI: l'ampiezza W del canale (massimi e",
            "#  minimi delle M1, che sono dati veri) e quindi la SCANSIONE di F, cioe' la",
            "#  distribuzione di W su 16,5 anni e la quota di giorni che passa il costo.",
            "#  OROLOGIO: 2008-2024.07 e' tutto VECCHIO orologio (server = ora di Londra",
            "#  tutto l'anno): l'ora %d ha lo stesso significato OGNI giorno. Verificato" % h,
            "#  sul repo solo dal 2018 (HistData) e dal 2020 (deal); 2008-2017 [NON",
            "#  VERIFICATO].",
            "#  GRAFICO H4 APPOSTA: il TF e' inerte (T1 lo prova sui tick) e H4 tiene",
            "#  ogni gamba a ~12.900 barre, sotto il tetto delle 100.000 anche senza",
            "#  MaxBars (su M5 la finestra farebbe ~1,24 milioni di barre).",
            "#  PREREQUISITO: profondita' M1 di %s sul banco misurata PRIMA (" % s,
            "#  scarica_storico.ps1 -Simboli \"%s\" -SoloReferto, LEGGIMI.md). Se parte" % s,
            "#  dopo il 2008.01.02 si scrive un file NUOVO con la data misurata, non si",
            "#  corregge questo dopo i numeri.",
            "#  ASSE: InpMinRangePips 0..70 passo 10 (8), b=3 fisso. Magic %d." % m,
        ]
    return r

def righe_pin(blocco, s, h, m, lett):
    comm = "R258%s LDN %s H%d" % (lett.upper(), s, h)
    if blocco == "G":
        mr = "InpMagic=%d||%d||50||%d||Y" % (m, m, m + 50)
        return pin(8, s, mr, B_TRE, F_ZERO, SM_ZERO, comm)
    if blocco == "B":
        fd = FDESIGNATO[s]
        return pin(8, s, magic_pin(m), B_ASSE, "InpMinRangePips=%d||%d||0||%d||N" % (fd, fd, fd), SM_ZERO, comm)
    if blocco == "D":
        return pin(8, s, magic_pin(m), B_TRE, F_ZERO, SM_ASSE, comm)
    return pin(h, s, magic_pin(m), B_TRE, F_ASSE, SM_ZERO, comm)

def direttive(blocco, s):
    per, da, a, fr = DIRETTIVE[blocco]
    return ["", "@SIMBOLO    %s" % s, "@PERIODO    %s" % per, "@DAQUANDO   %s" % da,
            "@FINOA      %s" % a, "@FRAZIONEIS %s" % fr, ""]

def scrivi(nome, righe):
    testo = "\n".join(righe) + "\n"
    testo.encode("ascii")  # muore se c'e' un carattere non ASCII
    with open(os.path.join(QUI, nome), "w", encoding="ascii", newline="\n") as fh:
        fh.write(testo)

TESTA = r"""
# =====================================================================
#  R258a -- LONDRA ORB ALL'ORA GIUSTA -- FILE DI TESTA DEL ROUND
#  EA: ABTG_Londra_ORB   (M5)   GBPUSD   ora 8 fissa
#  Ventiquattro file R258a..R258x: QUESTO porta TUTTI i criteri, gli altri
#  portano solo le proprie differenze e rimandano qui.
#  Scritto il 26/09/2026. ATTESE E SOGLIE CONGELATE PRIMA DEI NUMERI.
#  Generato da prove/R258_GENERA.py (tabelle di costo calcolate, non a
#  mano). Sorgente dell'EA: mql5/Experts/ABTG_Londra_ORB.mq5 (490 righe,
#  ultimo commit 3af47ed9), NON la copia piu' vecchia in standalone/.
# =====================================================================
#  GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. MAI SUL VPS (firma di
#  Claudio del 21/09/2026: sul VPS operano le sedie della challenge).
#  Prima si controlla che il terminale del PC non abbia sedie attaccate.
#  VINCOLI DI BANCO (stanno nella riga di lancio, classe 692):
#    -Deposito 10000 (rischio di banco InpRiskPercent=1.0, pinnato qui)
#    %s
#    NIENTE -Spread, NIENTE -Ritardo, NIENTE -FrazioneIS (il taglio lo da'
#    '@FRAZIONEIS' in ogni file; un -FrazioneIS diverso fa morire il driver),
#    MaxBars=100000000 come in R246/R251/R252/R253.
#    Blocco L (file o..t): -Modello 1, il resto uguale.
#  QUESTO FILE NON CONTIENE E NON AUTORIZZA NESSUNA RIGA DI LANCIO. Non
#  tocca EA, preset, sedie, conti, taglie o parametri del forward. Non
#  promuove niente in campo: ogni esito e' materiale per Claudio.
#
# =====================================================================
#  1. LA DOMANDA, E COSA E' GIA' MISURATO
# =====================================================================
#  Claudio, 26/09: "come aperture avevamo anche London breakout che
#  abbiamo abbandonato perche' perdeva spesso. potremmo analizzarla
#  meglio."
#  Il repo dice che NON e' mai stata misurata (REGISTRO_TEST.md r.120-130
#  e r.1337; caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md par. 0):
#   - ABTG_Londra_ORB non ha MAI avuto un CSV (git log --all, 22-23/09).
#     L'unico .ini (backtest_pipeline/ini/ABTG_Londra_ORB.ini) e' Model=1
#     (OHLC) dal 2024.01.01, cioe' sei mesi di tick fabbricati: NON si
#     riusa.
#   - R45 0/48 era ABTG_ORB_Ottimizzato: un ALTRO meccanismo (range
#     15-30', ingresso alla chiusura M5, EMA 9/21, SL all'estremo
#     opposto, TP in R). Non vale come misura di questo motore.
#   - R216a (23/09) ha disegnato la prima misura (SL MIDPOINT contro
#     OPPOSITE, ora 8 fissa, GBPUSD M5) e NON e' girato. R258 non la
#     duplica: tiene lo SL del PDF (MIDPOINT) e mette ad asse L'ORA e il
#     CANALE. >>> Il K1 di R216a (par. 7) conta il SOLO spread (40x ->
#     12,0 pip di stop); con la commissione forex (CANCELLO_COSTO_FLOTTA,
#     correzione dell'11/09) il 40x chiede 33,6 pip. Va corretto in R216a
#     PRIMA che giri: e' una segnalazione, questo round non lo tocca.
#  Certificato del 09/09: "NON ANCORA MISURATO", non morto.
#
# =====================================================================
#  2. IL PDF E L'EA: LO STESSO MOTORE. LE DEVIAZIONI, DICHIARATE
# =====================================================================
#  Scheda completa: caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md
#  (commit 032186b9). Qui solo cio' che tocca i pin di questo round:
#   - GBPUSD: si'. EURUSD e' il gemello (certificato p.4), non il PDF.
#   - canale = max/min dell'ora 07:00-08:00 ORA ITALIANA = SEMPRE Londra
#     -1h (Italia e Regno Unito cambiano ora nelle stesse domeniche). In
#     ora server BCM: ora 7 d'estate e nel vecchio orologio, ora 8 negli
#     inverni dal 2025 (par. 4).
#   - Buy Stop 3 pip sopra il max, Sell Stop 3 pip sotto il min:
#     InpBufferPips=3 (r.55; PipSize r.107-111 = 1 pip vero a 5 cifre).
#   - SL al CENTRO del canale: InpSLMode=0 MIDPOINT (r.60, r.214, r.229).
#   - TP = ingresso +/- W: InpTPRangeMult=1.0 (r.62, r.215, r.230).
#   - esempio del PDF: W 32 pip -> SL 19, TP 32. Lo stop vale W/2 + 3.
#  DEVIAZIONI (il PDF non le dice, l'EA le fa, qui restano come sono):
#   D-a OCO cablato (r.304, nessun interruttore), scadenza del pendente
#       240' (r.52, r.207), cutoff ingressi a ora+4 (r.46), chiusura
#       forzata a ora+9 (r.48, r.318-323): [NON DICHIARATO] nel PDF.
#   D-b "solo giornate senza notizie rilevanti": NON riproducibile nel
#       tester. Il filtro legge abtg_news.csv con FileOpen senza
#       FILE_COMMON (r.385) e il sorgente non ha '#property tester_file':
#       gli agenti del tester non ricevono il file e il filtro si spegne
#       da solo (r.386) [INFERITO dalle regole della sandbox del tester].
#       Pinnato a 0, dichiarato.
#   D-c verifica S/R su H1/H4/D1: discrezionale, non automatizzata (r.18).
#   D-d "variante prudente" (meta' size, SL agli estremi): e' R216a, e
#       l'EA la codifica diversa dal PDF (ANALISI par. 0 punto 5).
#   D-e il Buy Stop scatta sull'Ask: in prezzo Bid il buffer effettivo e'
#       3 - spread pip (0,3 alla mediana: irrilevante).
#
# =====================================================================
#  3. L'EA A HEAD -- VERDETTO: SANO PER LA LOGICA, MA CIECO
# =====================================================================
#  Letto riga per riga. Le classi di casa NON ci sono:
#   - niente OnTimer/EventSetTimer: tutto in OnTick con TimeCurrent (r.138);
#   - magic come input (InpMagic r.88), non fisso;
#   - lati pinnabili (InpAllowLong / InpAllowShort r.56-57);
#   - OnTester + OptFrame presenti (r.444-489): il driver lo accetta;
#   - lotto con OrderCalcProfit (r.346-350), conversione USD->EUR giusta.
#  Compilazione a HEAD: [NON VERIFICATA qui] (niente MetaEditor su Linux):
#  la stampa del driver "compilazione: OK / FALLITA" e' il primo cancello.
#  I DIFETTI, per nome e riga:
#   D1 CIECO: nessun per-trade (zero 'abtg_trades_' e zero FILE_COMMON
#      nel sorgente). OptFrame scrive SOLO Profit, EP, PF, RF, Sharpe,
#      Equity DD %, Trades e gli input (r.476). NON si leggono quindi:
#      orari d'uscita (S2), stop per operazione (K1 diretto), stagione per
#      riga, peggior giornata (R2), serie perdente (R3). Il round lo aggira
#      SENZA toccare l'EA: K1 dalla scansione di F (par. 7), stagioni per
#      gambe (blocco F), S2 e R2 strutturali (par. 7).
#   D2 InpOneTradePerDay (r.51) dichiarato e MAI letto (1 occorrenza in
#      490 righe). Innocuo: un ciclo al giorno lo impone la macchina a
#      stati (gPhase r.155-159, reset al cambio di giorno r.139).
#   D3 SelPos() = PositionSelect(_Symbol) (r.377) e PositionClose(_Symbol)
#      (r.142, r.321): su conto HEDGING vede la posizione piu' vecchia del
#      simbolo, di QUALUNQUE magic (report/AUDIT_POSITIONSELECT_HEDGING_
#      2026-09-03.md). Nel tester da solo: nullo. In campo accanto a
#      un'altra sedia GBPUSD: OCO cieco e chiusura sbagliata.
#   D4 nessun Guardian (zero InpUsaGuardian / ABTG_GuardiaIngresso): in
#      campo non rispetterebbe pausa B1 ne' cap C1. Irrilevante al banco.
#   D5 il canale include la barra M1 che apre all'ora di fine (r.175,
#      iBarShift exact=false: 61 barre). Al primo tick delle hh:00 quella
#      barra contiene solo quel tick. Effetto utile: il pendente sta sempre
#      almeno b pip oltre il prezzo, quindi non e' rifiutato per prezzo.
#   D6 scadenza ORDER_TIME_SPECIFIED (r.220, r.235): se il simbolo BCM non
#      la ammette, TUTTI i pendenti sono rifiutati -> Trades 0 -> E0/F0.
#   D7 PipSize (r.107-111) = _Point sui simboli a 2 cifre: su D30EUR e
#      100GBP "3 pip" = 0,03 punti indice. Indici NON supportati con la
#      semantica del PDF (par. 5).
#   D8 conto HEDGING: se i due pendenti si riempissero nello stesso tick
#      (gap), HandleOCO (r.304) arriverebbe tardi: due posizioni in un
#      giorno. Lo vede F0 (Trades > feriali).
#  VERDETTO: IL ROUND SI FA. L'EA e' sano per cio' che il round misura
#  (PF, n, DD, RF per cella). D1 obbliga a COSTRUIRE i cancelli invece di
#  leggerli; cio' che resta non misurabile e' al par. 9. D3/D4 sono
#  difetti DA CAMPO: bloccano uno schieramento, non questa misura.
#
# =====================================================================
#  4. L'OROLOGIO -- ORA FISSA E ORA IN FASE (terminologia di R255)
# =====================================================================
#  Fonte: report/OROLOGIO_BCM_2026-09-24.md par. 1-3 (~24.400 deal).
#  Forex BCM: VECCHIO orologio = ora italiana -1 tutto l'anno = ORA DI
#  LONDRA, fino al 26/12/2024 23:03 (ultimo segno); NUOVO = UTC+1 fisso al
#  piu' tardi dal 02/02/2025 23:05 (giorno esatto [NON MISURATO]).
#  Quindi l'apertura di Londra (08:00 locali) e il canale del PDF (Londra
#  -1h) cadono, IN ORA SERVER BCM:
#    periodo                          feriali  Londra   PDF
#    2024.07.05-2024.12.26 vecchio       125     08      07
#    2024.12.27-2025.02.02 AMBIGUO        26    08/09   07/08
#    2025.02.03-2025.03.28 inverno nuovo  40     09      08
#    2025.03.31-2025.10.24 estate        150     08      07
#    2025.10.27-2026.03.27 inverno       110     09      08
#    2026.03.30-2026.06.30 estate         67     08      07
#    2008.01-2024.07 (blocco L) vecchio 4307     08      07  [pre-2018 NON VERIFICATO]
#  I file girano a ORA FISSA (nessun EA di casa converte l'ora per data, e
#  l'EA non si tocca). In ogni file l'ora h pinna: canale (h-1):00-h:00,
#  ordini h:00, cutoff (h+4):00, chiusura (h+9):00:
#    ora 7 = PDF d'estate e nel vecchio orologio; Londra -2h d'inverno nuovo
#    ora 8 = LONDRA d'estate e nel vecchio orologio; PDF d'inverno nuovo
#    ora 9 = Londra +1h d'estate e nel vecchio; LONDRA d'inverno nuovo
#  Feriali in cui l'ora 8 e' in fase con Londra (blocco T): IS 141 su 207,
#  OOS 201 su 311; l'ora 9: IS 40 su 207, OOS 110 su 311; 26 feriali IS
#  ambigui. LA CURVA IN FASE si ricompone PER GAMBE nel blocco F, dove il
#  taglio IS/OOS cade sul cambio d'ora del 26/10/2025 (H2, par. 7).
#  PER FTMO: il server FTMO e' ora italiana +1 tutto l'anno (CLAUDE.md,
#  correzione del 24/09): un'ora fissa FTMO (le 10) E' in fase con Londra
#  tutto l'anno. Sul BCM no. Per questo la lettura IN FASE (H2) e' quella
#  che parla della challenge.
#
# =====================================================================
#  5. SIMBOLI -- E PERCHE' GLI INDICI NO
# =====================================================================
#  GBPUSD: il simbolo del PDF. EURUSD: il gemello piu' liquido della stessa
#  apertura (certificato p.4). Tick reali BCM dal 2024.07.05 per tutti e
#  due (backtest_pipeline/risultati_archivio/NOTA_PAVIMENTO_TICK_FOREX_
#  2026-09-01.md, Diario del tester: "ticks data begins from 2024.07.05").
#  >>> CORREZIONE DELLA PREMESSA "storico tick forex dal 1999": FALSA. Il
#  1999 e' il pavimento delle M1 (R102). Prima del 2024.07.05 i tick sono
#  GENERATI dalle M1 (e sulla famiglia breakout l'OHLC ha gonfiato il PF
#  del 71-125%, REGISTRO_TEST r.112). La finestra lunga entra SOLO come
#  screening (blocco L), e di li' si prende per buono solo W (par. 6).
#  D30EUR e 100GBP ESCLUSI, per due motivi indipendenti:
#   (1) SEMANTICA DELL'EA (D7): buffer e pavimento in "pip" = 0,01 punti
#       indice. Girarli misurerebbe un EA con buffer ~0, non il PDF.
#   (2) COSTO: 100GBP e' gia' ESCLUSA PER COSTO (report/MAPPA_COSTO_
#       SIMBOLI_TF_2026-09-24.md r.306, 16,5x-25,2x). D30EUR: il "canale di
#       Londra" 07-08 server e' il PRE-Xetra; spread 1,60 alle 7 server
#       (logger vivo), il 40x chiede stop >= 64 punti = W >= ~128 punti
#       nell'ora di pre-apertura [INFERITO improbabile; W di pre-apertura
#       NON MISURATO].
#  Il "1,2x-8,8x" di REGISTRO r.120 NON si trasferisce: era il Live5m su
#  M5; qui il TF e' inerte e il costo dipende da W, non dal TF.
#  Non sono "morti": sono fuori dal perimetro di questo EA.
#
# =====================================================================
#  6. IL DISEGNO: 6 BLOCCHI, 24 FILE, 158 CELLE, 316 PASSATE
# =====================================================================
#  L'ASSE DELL'ORA 7/8/9: tutto trasla INSIEME (canale, ordini, cutoff,
#  chiusura): l'unica cosa che cambia e' l'orologio. Un file per ora (MT5
#  non co-varia quattro input). UN SOLO ASSE PER FILE (regola di casa,
#  controlla_prova.py): la scansione del canale, il buffer, la durata e le
#  gemelle stanno in file diversi, legati da controlli incrociati (X1).
#  IL TF E' INERTE per costruzione (canale su PERIOD_M1 cablato, r.174-
#  184; ingressi con pendenti; OnTick a ogni tick; trailing spento). Un
#  asse M5/M15/M30 darebbe celle identiche: al suo posto T1 (blocco G) lo
#  PROVA, e la manopola equivalente (certificato p.5) e' la DURATA del
#  canale 60'/30' (blocco D).
#   T  a..f  tick, finestra intera, ORA FISSA    6 file x 8 righe (F 0..70)
#                                                 =  48 celle,  96 passate
#   F  i..n  tick, gambe ESTATE | INVERNO 25/26   6 file x 8 righe (F 0..70)
#                                                 =  48 celle,  96 passate
#   L  o..t  OHLC M1 2008.01-2024.07, grafico H4  6 file x 8 righe (F 0..70)
#            SCREENING                            =  48 celle,  96 passate
#   G  g,h   tick, grafico M30, ora 8, F=0        2 file x 2 (gemelle)
#                                                 =   4 celle,   8 passate
#   B  u,v   tick, ora 8, F DESIGNATO, b 1/3/5    2 file x 3 = 6 celle, 12 passate
#   D  w,x   tick, ora 8, F=0, canale 60'/30'     2 file x 2 = 4 celle,  8 passate
#  F = InpMinRangePips (pavimento del canale, r.198); b = InpBufferPips,
#  3 (il PDF) in tutti i file tranne B.
#  LA SCANSIONE DI F e' il cuore del round: le righe con F piu'
#  alto operano un SOTTOINSIEME ESATTO delle giornate di quelle con F piu'
#  basso (stesso canale, stessi prezzi dei pendenti, stesso innesco; r.198
#  salta solo il giorno). Quindi Trades(b, F) / Trades(b, 0) E' la
#  distribuzione dell'ampiezza W del canale sulle giornate operate: il
#  PRIMO numero che l'analisi del PDF chiede, e il cancello del costo si
#  legge senza per-trade (K1, par. 7). Nel blocco L W viene da massimi e
#  minimi M1 VERI: la distribuzione di W su 16,5 anni e' affidabile anche
#  li', il P/L no.
#  MAGIC (tutti fissi tranne g/h), vergini: zero occorrenze su 23 ref git
#  e sul disco del server di sviluppo (unico riscontro: il registro di
#  questa sessione), grep del 26/09:
#    T  a 795808  b 795807  c 795809  d 795818  e 795817  f 795819
#    G  g 795840/795890  h 795841/795891
#    B  u 795860  v 795861        D  w 795870  x 795871
#    F  i 795827  j 795828  k 795829  l 795837  m 795838  n 795839
#    L  o 795847  p 795848  q 795849  r 795857  s 795858  t 795859
#
#  6.2 LE ATTESE, DICHIARATE PRIMA DEI NUMERI [STIMA, nessuna misura]
#   (A) FREQUENZA: un ciclo OCO al giorno -> Trades <= feriali (T: 207 /
#       311). Innesco atteso con b=3, F=0: 75-97% dei feriali -> T ancora
#       IS 155-200, OOS 233-302. Blocco F: estate 113-146, inverno 83-107
#       (merito SOSPESO per aritmetica in ogni gamba; composto 195-252).
#   (B) AMPIEZZA W: mediana del canale PDF (pre-apertura, Londra -1h) fra
#       12 e 25 pip; del canale Londra (prima ora) fra 20 e 40 pip; EURUSD
#       circa 0,7 volte GBPUSD. Quota di giornate operate col W che passa il
#       40x ALL-IN (GBPUSD W >= 61,2 a b=3; EURUSD W >= 47,1): < 10% all'ora
#       7, < 20% all'ora 8.
#   (C) COSTO: righe F=0 attese FRAGILI o ESCLUSE (stop mediano 9-23 pip =
#       11-27x all-in su GBPUSD). Le righe DESIGNATE (F=70 GBPUSD, F=50
#       EURUSD) AMMESSE per costruzione ma con n sotto 150 -> MERITO SOSPESO
#       per aritmetica. E' l'esito ATTESO, non un fallimento: il round dice
#       QUANTI giorni il PDF e' pagabile, e a che ora.
#   (D) ORA: attesa strutturale W(ora 8) > W(ora 7), cioe' stop piu'
#       larghi e costo piu' leggero all'apertura vera. Sul PF nessuna
#       attesa: e' la domanda.
#
# =====================================================================
#  7. CANCELLI, CONGELATI PRIMA DEI NUMERI (valgono per TUTTI i R258)
# =====================================================================
#  Si leggono dal CSV di OptFrame (r.476): Profit, PF, RF, Equity DD %,
#  Trades e le colonne Inp*. DD_fisso% = |Profit / RF| / 100 a deposito
#  10000 (come R251 r.335): RF = profitto / DD massimo dell'equity, quindi
#  |Profit / RF| e' quel DD in euro. Il picco d'equity e' sempre >= 10000,
#  quindi DD_fisso% >= Equity DD % relativo SEMPRE: R1 su DD_fisso e' il
#  piu' severo dei due. Con Profit = 0 esatto RF non si calcola: si scrive
#  l'Equity DD % e [NON CALCOLABILE]. Trades = posizioni (niente parziale).
#
#  CATENA (se uno fallisce: NULLO, non un verdetto)
#   E0  ogni file da' _IS.csv e _OOS.csv con UNA riga per cella (T, F, L
#       8; G 2; B 3; D 2) e Trades > 0 in ogni riga F=0. Un EA che non
#       compila (stampa del driver) e' NULLO prima di E0.
#   P0  PIN DAL CSV: in ogni riga le colonne Inp* = i pin del file:
#       InpRangeStartHour ora-1, InpRangeEndHour e InpPlaceHour ora,
#       InpEntryCutoffHour ora+4, InpCloseHour ora+9, InpSLMode 0,
#       InpTPRangeMult 1, InpRiskPercent 1, InpUsePartial 0, InpUseTrailing
#       0, InpUseNewsFilter 0, InpMaxSpread 0, InpPendingExpiryMin 240,
#       InpHalveOnOpposite 0, InpMagic del file; gli assi coi valori attesi.
#       Contro-esempio: pin d'ora non arrivati -> default compilati
#       6/7/7/11/17 -> il file ora 8 misurerebbe l'ora 7. S1 vede che due
#       file sono uguali, P0 dice QUALE ora ha girato.
#   F0  FREQUENZA: Trades <= feriali della gamba in OGNI riga (T, G, B, D: 207 /
#       311; F: 150 / 110; L: 2153 / 2154). Sopra = piu' di una posizione
#       al giorno (D8) -> file NULLO. Nelle righe F=0 anche Trades >= 0,30 x
#       feriali; sotto = M1 mancanti o pendenti rifiutati (D6) -> NULLO.
#   F1  LA SCANSIONE MORDE (T, F, L): Trades NON crescente in F, con almeno
#       un calo stretto fra 0 e 70. Contro-esempio: InpMinRangePips non
#       arrivato -> otto righe identiche -> NULLO.
#   G1  DETERMINISMO (g, h): le gemelle (magic e magic+50) hanno Profit,
#       PF, RF, Equity DD %, Trades identici, IS e OOS.
#   T1  TF INERTE (g, h): le righe di g (M30) = la riga F=0 di a (M5);
#       quelle di h = la riga F=0 di d. Profit, PF, Trades, Equity DD % al
#       centesimo, IS e OOS. Diverse = l'EA dipende dal grafico, contro il
#       sorgente: TUTTO il round NULLO fino a diagnosi.
#   X1  IDENTITA' FRA FILE (stessi pin di trading, cambiano magic e
#       commento): riga b=3 di u = riga F=70 di a; riga b=3 di v = riga
#       F=50 di d; riga StartMin=0 di w = riga F=0 di a; di x = F=0 di d.
#       Al centesimo, IS e OOS. Diverse = un pin non e' arrivato: i file
#       coinvolti NULLI.
#   S1  L'ORA MORDE: per simbolo e per blocco (T, F, L) le righe b=3 F=0
#       dei tre file d'ora differiscono a due a due in Trades o Profit, in
#       ogni gamba. Uguali = pin non arrivati -> quei file NULLI.
#   X0  (non bloccante) CONCORDANZA CON R216a, se nel frattempo e' girato:
#       la sua riga InpSLMode=0 (magic 786601) = la riga b=3 F=0 di R258a
#       al centesimo (stessa finestra, stesso taglio, stessi pin di
#       trading; cambiano magic e commento). Se no: stop e diagnosi.
#   S2  USCITE DENTRO LA GIORNATA: [NON MISURABILE] (D1), GARANTITO DAL
#       CODICE: pendenti cancellati a ora+4 (r.148-153), posizione chiusa a
#       ora+9 (r.145, r.318-323) = 16/17/18 server, prima del rollover delle
#       22 (GBPUSD 8,0 pip alle 22, logger vivo). Nessuna notte, nessuno
#       swap. Si guarda sulla corsa singola di C-COMM.
#   C-COMM IL TESTER ADDEBITA LA COMMISSIONE FOREX? [NON VERIFICATO]. Si
#       verifica PRIMA di leggere M1 con UNA corsa singola (non
#       un'ottimizzazione) della riga b=3 F=0 di R258a, Report del tester
#       salvato: la Commissione deve essere != 0 (attesa ~4 EUR a lotto giro
#       completo su EURUSD, ~4,65 EUR su GBPUSD: CANCELLO_COSTO_FLOTTA
#       r.186-190). Se e' ZERO ogni PF di R258 e' LORDO di ~0,54 / 0,46 pip
#       a operazione: M1 si scrive "LORDO DI COMMISSIONE" e NESSUNA riga
#       puo' essere promossa.
#
#  COSTO (K1) -- vale a qualunque n
#   Costo all-in c = spread mediano ore 07-12 server (logger vivo 04-11/09,
#   data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv) + commissione
#   MISURATA (prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md r.70-73):
#     GBPUSD 0,300 + 0,540 = 0,840 pip      EURUSD 0,200 + 0,464 = 0,664 pip
#   (l'ANALISI del PDF usa 0,53 derivato dal cambio: 0,83 pip, W >= 60,4;
#   qui la commissione MISURATA: 0,84 pip, W >= 61,2. Differenza < 1 pip.)
#   Pavimenti di casa: 40x di lavoro, 13,3x duro (R125_ORB_COSTO_CRITERI
#   par. 2). Lo stop dell'EA vale W/2 + b (r.203-216). Lo stop MEDIANO di
#   una riga (b, F) si legge senza per-trade:
#     F* = il piu' grande G della griglia, G >= F, con
#          Trades(b, G) >= 0,5 x Trades(b, F)        (sottoinsiemi, F1)
#     => W mediano in [F*, F*+10) => stop mediano in [F*/2+b, (F*+10)/2+b)
#   AMMESSA          se F*/2 + b >= 40 c
#   ESCLUSA PER COSTO se (F*+10)/2 + b <= 13,3 c
#   FRAGILE          se l'intervallo sta fra 13,3 c e 40 c
#   NON RISOLTA      se l'intervallo scavalca una soglia: si scrive nella
#                    banda PEGGIORE. Con F* = 70 (tetto della griglia) vale
#                    solo il limite inferiore.
#   Esempio del PDF (W 32, stop 19): 22,6x all-in su GBPUSD = FRAGILE
#   (63,3x sul solo spread: e' la commissione il termine che decide).
#   IL PRIMO NUMERO DEL REFERTO: per ogni file la curva Trades(b=3, F) /
#   Trades(b=3, 0) per F = 0..70 (distribuzione di W sulle giornate
#   operate) e Trades / feriali (quota dei giorni).
#
#  RISCHIO -- a QUALUNQUE n. Una VIOLAZIONE vale sempre, il rispetto a n
#  piccolo no (classe 804)
#   R1  DD_fisso% <= 5,0 in OGNI gamba, in ogni riga dei blocchi T, G, F.
#       FONTE: R216a par. 8(C), stesso EA, congelato il 23/09 prima di ogni
#       numero: 5,0 al banco x fattore di casa 1,956-1,990 = 9,78-9,95% alla
#       taglia FTMO del 2,00% = il muro del 10%. PERCHE' NON 6,5 (R253): era
#       il DD di 8 anni di una sonda esterna di un ALTRO motore, e alla
#       taglia FTMO varrebbe 12,7-12,9%, oltre il muro.
#       R1 violato = BOCCIATA PER RISCHIO a qualunque n. Rispettato con
#       Trades < 150 = "R1 NON VIOLATO su n = X", mai "rischio passato".
#       Blocco L: il DD su gambe di 8 anni a rischio fisso NON e' il DD di
#       una challenge e non si confronta col muro. Si scrive, e sopra 5,0
#       si annota "ALLARME DI REGIME (screening)" accanto alla riga.
#   R2  PEGGIOR GIORNATA: [NON MISURABILE] (D1). Strutturale: <= 1
#       posizione al giorno (F0), perdita <= 1R + slittamento + commissione
#       = ~2% alla taglia FTMO, sotto il muro giornaliero del 5%.
#   R3  SERIE PERDENTE: [NON MISURABILE] (D1).
#
#  MERITO -- SOLO blocco T, SOLO con Trades OOS >= 150 (Emendamento A)
#   M1  PF OOS >= 1,10.
#   M2  RF OOS >= 0,80 (R216a par. 8(B)).
#   M3  L'IS NON RIBALTA: Trades IS >= 150 e PF IS >= 1,00. Con Trades IS
#       < 150: M3 SOSPESO, la riga arriva al massimo a INDIZIO.
#   M4  ALTOPIANO, MAI IL PICCO (file B, solo righe designate): b=1, b=3
#       e b=5 passano TUTTE R1 e M1. Vince solo il CENTRO; un bordo che
#       sporge da solo = "DIREZIONE INDICATA, NON UNA CONFIGURAZIONE".
#   Accanto a ogni M1 VERDE si scrive la probabilita' che un motore SENZA
#   edge lo passi a quell'n (par. 8): 0,30 a n 150, 0,24 a n 233, 0,22 a
#   n 300 (lordo di costi). M1 da solo NON separa l'edge dal caso.
#   RIGHE DESIGNATE, le SOLE promuovibili, scelte ORA per non pescare fra
#   158 celle: ora 8 (Londra), b=3, e il piu' piccolo F della griglia il
#   cui stop MINIMO passa gia' il 40x all-in:
#     GBPUSD R258a (b=3, F=70): stop >= 38,0 pip = 45,2x
#            (F=60 darebbe 33,0 pip = 39,3x: fuori per un soffio)
#     EURUSD R258d (b=3, F=50): stop >= 28,0 pip = 42,2x
#   Ogni altra riga e' MAPPA: se passa tutto e' "DIREZIONE INDICATA" per il
#   round dopo, mai promossa da questo.
#
#  L'ORA -- la domanda del round ("e' la misura che decide fra le due
#  convenzioni", coordinatore 26/09)
#   Soglia di rumore TARATA (par. 8) sul n PIU' PICCOLO delle due righe:
#   delta(n) = 0,40 per n < 233 ; 0,33 per 233 <= n < 300 ; 0,28 per
#   300 <= n < 1900 ; 0,11 per n >= 1900. Con n < 150: l'ora NON E'
#   LEGGIBILE.
#   H1  ORA FISSA (blocco T, righe b=3 F=0): "X BATTE Y" se PF OOS(X) -
#       PF OOS(Y) >= delta E Profit OOS(X) > Profit OOS(Y) E PF IS(X) > PF
#       IS(Y). Coppie: 8 contro 7 (Londra contro PDF in ~2/3 dei feriali) e
#       9 contro 8. Altrimenti "L'ORA NON DECIDE (entro il rumore)".
#   H2  IN FASE (blocco F, righe b=3 F=0): LONDRA IN FASE = gamba estate
#       dell'ora 8 + gamba inverno dell'ora 9; PDF IN FASE = estate
#       dell'ora 7 + inverno dell'ora 8. Composizione per gambe (ogni
#       gamba parte da 10000): GL = Profit / (PF - 1), GP = PF x GL, PF
#       composto = somma GP / somma GL; con |PF - 1| < 0,005 in una gamba:
#       NON CALCOLABILE. "LONDRA IN FASE BATTE IL PDF IN FASE" se Profit
#       migliore in TUTTE E DUE le stagioni E PF composto migliore di
#       almeno delta(n composto). Una sola finestra annua: al massimo
#       INDIZIO. E' la lettura che parla di FTMO (par. 4).
#   H3  SCREENING (blocco L, vecchio orologio 2008-2024): l'ordine dei PF
#       per ora e' lo stesso nelle due gambe (2008-16, 2016-24) con scarti
#       >= delta(1900) = 0,11? Dice se l'effetto dell'ora ha una storia,
#       non se paga.
#
#  ESITI PER RIGA, in quest'ordine:
#   NULLO                catena rossa (E0, P0, F0, F1, G1, T1, X1, S1)
#   BOCCIATA PER RISCHIO R1 violato, a qualunque n
#   ESCLUSA PER COSTO    K1 sotto 13,3x
#   SOSPESA              Trades OOS < 150: merito sospeso, rischio giudicato
#   INDIZIO FAVOREVOLE   M1-M4 verdi ma riga non designata, o K1 non
#                        AMMESSA, o C-COMM non verificato, o M3 sospeso
#   PROMOSSA AL PASSO SUCCESSIVO  riga DESIGNATA, tutto verde, C-COMM
#                        verificato. MAI "in campo": prima D3/D4 (par. 3),
#                        l'orologio per data e la firma di Claudio.
#  COSA CHIUDE IL CANDIDATO (scritto prima): se su GBPUSD E su EURUSD le
#  righe F=0 delle tre ore hanno PF OOS < 1,00 con Trades OOS >= 150 e K1
#  FRAGILE o ESCLUSO, il verdetto va in REGISTRO_TEST.md con PF, n, DD e
#  cancello; il certificato resta "NON ANCORA MISURATO" solo finche' manca
#  il p.3 (gestione dell'uscita), cioe' R216a.
#
# =====================================================================
#  8. I CONTRO-ESEMPI, COSTRUITI PER FAR SBAGLIARE QUESTO ROUND
# =====================================================================
#  (a) "Due ore diverse sono solo rumore": QUALE numero produce? Simulato
#      (seme 258, 4.000 coppie, prove/R258_rumore.py, ~5 min): motore
#      SENZA edge con la geometria del PDF (W 25 -> SL 15,5, TP 25, payoff
#      1,61R, p 0,383), esito binario = varianza MASSIMA (le uscite a tempo
#      la riducono, quindi le bande sono prudenti). Due righe indipendenti:
#        n OOS  n IS | P(PF>=1,10) | |dPF| q90  q95 | falso "decide" a 0,10 / a q90
#         150   100  |   0,300     |  0,395  0,477 |   0,319 / 0,050
#         233   155  |   0,243     |  0,330  0,385 |   0,287 / 0,043
#         300   200  |   0,218     |  0,281  0,330 |   0,267 / 0,048
#        1900  1900  |   0,025     |  0,111  0,132 |   0,066 / 0,051
#      (al netto del costo all-in, 0,054 R a operazione, i q90 scendono di
#      0,02-0,04: si tiene la colonna LORDA, piu' larga.)
#      >>> La soglia di casa +0,10 (R251 M2) qui DECIDEREBBE SUL RUMORE
#      nel 27-32% dei casi: per l'ora NON si usa. delta(n) = q90 = falso
#      "decide" <= 5%. Le righe delle tre ore stanno sugli STESSI giorni
#      (correlate): il rumore vero della differenza e' MINORE, quindi delta
#      e' prudente (decide meno spesso, mai di piu').
#  (b) "La scansione non ha morso" -> F1.
#  (c) "Il TF conta perche' il tester non serve le M1" -> T1 (M30 = M5).
#  (d) "I pin d'ora non sono arrivati" -> P0 prima di S1.
#  (e) "Il DD e' basso perche' il conto e' cresciuto" -> R1 su DD_fisso.
#  (f) "Il PF e' buono perche' il tester non addebita la commissione" ->
#      C-COMM prima di M1.
#  (g) "Due posizioni al giorno gonfiano n" -> F0.
#
# =====================================================================
#  9. COSA R258 NON MISURA (dichiarato)
# =====================================================================
#   - la curva IN FASE riga per riga (D1): solo per gambe (H2), su UN anno;
#   - orari d'uscita, peggior giornata, serie perdente (D1): S2, R2, R3;
#   - il filtro notizie del PDF (D-b) e la verifica S/R (D-c);
#   - la gestione dell'uscita (SL mode, TP, parziale, trailing): e' R216a
#     e un round dopo (certificato p.3);
#   - i due lati separati: il motore e' OCO, spegnerne uno e' un'altra
#     strategia (R216a par. 10); il CSV li somma;
#   - requote, rifiuti, esecuzione della prop vera; lo spread STORICO
#     2024-26 del tester contro quello del logger di settembre 2026 [NON
#     VERIFICATO]; il giorno esatto del cambio d'orologio (26 feriali IS
#     ambigui nel blocco T);
#   - l'orologio BCM prima del 2018 (blocco L) [NON VERIFICATO];
#   - la frequenza di FAMIGLIA: <= 1 operazione al giorno per simbolo.
#
# =====================================================================
#  10. TEMPO MACCHINA [STIMA, non misurata su questo EA]
# =====================================================================
#   Tasso usato nelle stime di casa per corse forex/indici a tick sul banco:
#   ~5-9 s a passata (report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md r.64-65;
#   CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md r.92: EMA200 H4 GBPUSD, 48
#   passate ~4,3 min). Anche quello e' una proiezione. OnTick di questo EA
#   e' O(1): due PositionSelect e un TimeToStruct a tick.
#     T   96 passate                          8-15 min
#     G+B+D  28 passate                       2-5 min
#     F   96 passate (gambe ~meta' di T)      4-8 min
#     L   96 passate OHLC M1 (~12 M tick a gamba, stesso ordine di una
#         gamba T)                            8-16 min + download M1 2008+
#   TOTALE ~25-45 minuti + compilazione. Ordine consigliato: a, b, c
#   (GBPUSD, la domanda) -> g, u, w -> i, j, k -> d, e, f, h, v, x, l, m, n
#   -> L (dopo
#   il prerequisito di profondita' M1, e EURUSD r, s, t per primo come
#   canarino: M32 in PIANO_PROP r.1925 ha visto GBPUSD ~30x piu' lento di
#   EURUSD su tick GENERATI). Ogni gamba sta sotto le 100.000 barre anche
#   senza MaxBars: T su M5 59.616 / 89.568; F su M5 43.200 / 31.680; G su
#   M30 ~9.900 / ~14.900; L su H4 ~12.900 a gamba.
#
# =====================================================================
#  11. IL CERTIFICATO (09/09) DOPO R258
# =====================================================================
#   p.1 PF misurato ........ SI' (il primo della storia di questo EA)
#   p.2 n e DD ............. SI'
#   p.3 gestione dell'uscita NO -> R216a (SL mode) + un asse sul TP
#   p.4 simboli gemelli .... SI' (EURUSD)
#   p.5 TF cambiato ........ T1 prova che e' inerte; manopola equivalente =
#                            durata del canale 60'/30' (blocco D, ora 8)
#   Senza R216a il verdetto massimo in negativo resta "NON ANCORA
#   MISURATO (manca p.3)".
"""


def main():
    testa = [l for l in TESTA.strip("\n").split("\n")]
    testa = [x if "%s" not in x else x % MODELLO["T"] for x in testa]
    for lett, blocco, s, h, m, nome in FILES:
        if lett == "a":
            r = list(testa)
            r += ["#", "#  IL COSTO DI QUESTO FILE (GBPUSD), calcolato da R258_GENERA.py:"]
            r += tabella_costo("GBPUSD")
            r += ["#", "#  E PER IL GEMELLO (EURUSD, file d/e/f/h/l/m/n/r/s/t):"]
            r += tabella_costo("EURUSD")
            r += ["# ====================================================================="]
        else:
            r = testa_breve(lett, blocco, s, h, m, nome)
            r += corpo_blocco(lett, blocco, s, h, m)
            r += ["# ====================================================================="]
        r += direttive(blocco, s)
        r += righe_pin(blocco, s, h, m, lett)
        scrivi(nome, r)
        print("scritto", nome)

if __name__ == "__main__":
    main()
