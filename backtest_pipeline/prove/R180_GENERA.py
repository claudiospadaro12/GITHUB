#!/usr/bin/env python3
# =====================================================================
#  R180_GENERA.py -- fabbrica le SETTE celle del DUELLO DEGLI INGRESSI
#                    sul DOW (U30USD), piu' il canarino sull'EA VIVO.
#  Scritto il 18/09/2026. ASCII puro.
# ---------------------------------------------------------------------
#  PERCHE' UN GENERATORE E NON SETTE FILE SCRITTI A MANO.
#  Il duello ha senso SOLO se le celle differiscono nell'INGRESSO e in
#  NIENT'ALTRO. Scritte a mano, "in nient'altro" e' una promessa; scritte
#  da qui, e' un fatto meccanico: il corpo dei parametri e' UNA sola
#  struttura Python, e le uniche cose che cambiano per cella sono
#  InpEntryMode, InpAllowShort (fra le due FAMIGLIE, mai dentro una) e
#  InpMagic.
#  Il contro-esempio si verifica cosi', e va rifatto a ogni modifica:
#      diff <(grep -v '^#' R180u0_stop_U30USD.txt) \
#           <(grep -v '^#' R180u1_limit_U30USD.txt)
#  Deve stampare DUE sole differenze: InpEntryMode e InpMagic.
#
#  USO:  python3 backtest_pipeline/prove/R180_GENERA.py
# =====================================================================
import os

QUI = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------
#  IL CORPO. Ogni valore viene dalla CELLA VIVA DEL DOW, magic 770202,
#  letta da mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set
#  (foto del .chr del 06/09/2026) e da
#  backtest_pipeline/prove/R103_ABTG_Dow_Apertura_US_U30USD_770202.txt.
#  Le TRE sole divergenze rispetto alla cella viva sono dichiarate nel
#  cappello dei file e nei criteri: rischio 1,0% (banco), Guardian
#  assente nell'EA del duello, InpVerbose spento.
# ---------------------------------------------------------------------
CORPO = [
 ("--- SESSIONE (ORE DEL SERVER BCM, mai l'ora italiana): 14:30 server = 15:30 IT, apertura cash USA", [
    ("InpSessionHour",      "14"),
    ("InpSessionMin",       "30"),
    ("InpRangeMinutes",     "35"),
    ("InpCloseHour",        "17"),
    ("InpCloseMin",         "30"),
    ("InpCloseAtEnd",       "1"),
    ("InpOneTradePerDay",   "1"),
    ("InpMaxPosSimbolo",    "0"),
 ]),
 ("--- INGRESSO: InpEntryMode E' L'UNICA COSA CHE CAMBIA DENTRO UNA FAMIGLIA", [
    ("InpEntryMode",        "@ENTRY@"),
    ("InpRangeMode",        "0"),
    ("InpLevelTF",          "16385"),
    ("InpPrevWindowMin",    "60"),
    ("InpBufferPoints",     "1000"),
    ("InpOCTimeframe",      "0"),
    ("InpPendingExpiryMin", "120"),
    ("InpAllowLong",        "1"),
    ("InpAllowShort",       "@SHORT@"),
    ("InpMinRangePts",      "0"),
    ("InpMaxRangePts",      "0"),
    ("InpRetestOffsetPts",  "400"),
    ("InpFadeOffsetPts",    "0"),
    ("InpUseGapFill",       "0"),
    ("InpGapMinPoints",     "150"),
    ("InpGapMinRR",         "1.5"),
    ("InpDelayMinutes",     "30"),
    ("InpDelayDirMode",     "0"),
 ]),
 ("--- FILTRI: la cella viva del Dow ha l'EMA ACCESA (1/50 su H4). Non e' un\n#     refuso e non si spegne: spegnerla vorrebbe dire duellare su una cella\n#     che non esiste in campo. E' la DIVERGENZA DICHIARATA rispetto a R83,\n#     dove tutti i filtri erano spenti. Tutti gli ALTRI filtri sono spenti,\n#     identici nelle sei celle.", [
    ("InpUseEmaFilter",     "1"),
    ("InpEmaFast",          "1"),
    ("InpEmaSlow",          "50"),
    ("InpFilterTF",         "16388"),
    ("InpUseSupertrend",    "0"),
    ("InpStAtrPeriod",      "10"),
    ("InpStMultiplier",     "2.5"),
    ("InpStTF",             "16385"),
    ("InpUseSupertrend3",   "0"),
    ("InpUseCorrelation",   "0"),
    ("InpCorrTF",           "16385"),
    ("InpCorrEmaFast",      "14"),
    ("InpCorrEmaSlow",      "100"),
    ("InpUseVwapFilter",    "0"),
    ("InpVwapTF",           "15"),
    ("InpUseVolumeFilter",  "0"),
    ("InpVolMult",          "1.5"),
    ("InpVolAvgBars",       "20"),
    ("InpUseAtrFilter",     "0"),
    ("InpAtrFilterBars",    "20"),
    ("InpAtrFilterMult",    "1.0"),
    ("InpConfirmMode",      "0"),
    ("InpUseNewsFilter",    "0"),
 ]),
 ("--- RISCHIO E GESTIONE: IDENTICI in tutte e sei le celle del duello.\n#     Se cambiasse anche solo il trailing, il round misurerebbe due cose\n#     insieme. InpTP1_R=1.0 e InpTP1_ClosePct=50 sono i valori della CELLA\n#     VIVA, non i default del sorgente (0.5 / 0): il progetto ha gia' pagato\n#     due volte l'errore InpTP1_ATRmult=0 contro 0.5, qui si copia, non si\n#     ricorda.", [
    ("InpRiskPercent",      "1.0"),
    ("InpSLMode",           "0"),
    ("InpAtrSlMult",        "1.5"),
    ("InpAtrPeriodMgmt",    "14"),
    ("InpTP1_R",            "1.0"),
    ("InpTP1_ClosePct",     "50"),
    ("InpBreakevenAtTP1",   "1"),
    ("InpBEatR",            "0"),
    ("InpUseTrailing",      "1"),
    ("InpTrailStartR",      "0"),
    ("InpTrailMode",        "1"),
    ("InpTrailTF",          "5"),
    ("InpTrailAtrMult",     "2.0"),
    ("InpTrailFixedPts",    "410"),
    ("InpUseRoundLevels",   "0"),
    ("InpRoundStep",        "100.0"),
    ("InpRoundMinDistPts",  "50"),
 ]),
 ("--- SLIPPAGE ZERO, E VA DICHIARATO. Nel motore InpSlippagePts peggiora\n#     SOLO gli ordini STOP: il limit del retest e il market della conferma\n#     non lo pagano. Con 0 la modalita' 0 e' AVVANTAGGIATA (criteri par.7).\n#     InpMinStopPts=500 e InpSkipIfTight=0 sono della CELLA VIVA e NON sono\n#     i default del sorgente del duello (0 e true): senza queste due righe\n#     si misurerebbe un'altra strategia.", [
    ("InpSlippagePts",      "0"),
    ("InpMinStopPts",       "500"),
    ("InpSkipIfTight",      "0"),
 ]),
 ("--- LE LEVE R30 (esistono nel motore del duello, NON esistono nell'EA vivo\n#     del Dow): PINNATE SPENTE. Senza questo pin il canarino non potrebbe\n#     coincidere.", [
    ("InpUseVolRegime",     "0"),
    ("InpUseSRFilter",      "0"),
 ]),
 ("--- GENERALI", [
    ("InpMaxSpread",        "0"),
    ("InpVerbose",          "0"),
    ("InpAutoTest",         "1"),
 ]),
]

CAPPELLO = """# =====================================================================
#  R180 / DUELLO DEGLI INGRESSI SUL DOW -- U30USD -- {titolo}
#  EA: ABTG_Apertura_3Ingressi
#  FAMIGLIA: {famiglia}
#
#  Si lancia con:
#    -Prova prove\\{nome} -Etichetta {etichetta} -Modello 4 -Deposito 10000
#
#  I CRITERI SI LEGGONO PRIMA DEI NUMERI: prove\\R180_DUELLO_DOW_CRITERI.md
#  LA DOMANDA: "a parita' ASSOLUTA di livello, orario, stop, gestione e
#  uscite, quale STILE D'INGRESSO regge meglio SUL DOW?"
#  R83 ha fatto questo duello su D30EUR e NASUSD. SU U30USD MAI.
# ---------------------------------------------------------------------
#  QUESTA CELLA
{descrizione}
# ---------------------------------------------------------------------
#  DA DOVE VIENE OGNI VALORE, e non e' a memoria:
#    mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set
#    (foto del .chr vivo del 06/09/2026, sedia 770202) e
#    prove/R103_ABTG_Dow_Apertura_US_U30USD_770202.txt.
#  Questo file NON e' scritto a mano: lo genera prove/R180_GENERA.py, e
#  per costruzione il corpo dei parametri e' lo stesso in tutte le celle.
#
#  LE TRE DIVERGENZE DALLA CELLA VIVA, DICHIARATE:
#    1. InpRiskPercent 1,0% (banco) contro 0,65% (campo, 100k): e' la
#       convenzione di casa per confrontare MOTORI e non TAGLIE. Il DD a
#       0,65% resta un APPROSSIMATO lineare, mai una misura.
#    2. InpUsaGuardian NON ESISTE nell'EA del duello. Nel canarino
#       (R180uV) l'EA vivo gira con Guardian SPENTO, per rendere le due
#       corse confrontabili.
#    3. InpVerbose spento (nella cella viva e' acceso): qui non serve a
#       nessun cancello e gonfierebbe il log.
#
#  LA FINESTRA, E CHE COSA NON CONTIENE
#    @DAQUANDO 2024.09.26 e' la profondita' MISURATA dei dati BCM sul Dow.
#    E i TICK REALI ci sono e sono misurati -- questa non e' piu' una
#    incognita come in R83: risultati_archivio/ABTG_StoricoScaricato.csv
#    (corsa dell'08/09/2026) porta la riga
#        U30USD,TICK,68558736,2024.09.26,-,COMPLETO
#    quindi -Modello 4 e' legittimo su tutta la finestra.
#
#    REGIME CONTENUTO: uno e mezzo. Toro USA 2024-2025 + correzione 2025.
#    NIENTE 2020, NIENTE 2022. Questo round misura RIEMPIMENTO e STILE
#    D'INGRESSO, MAI la robustezza di regime.
# =====================================================================
@SIMBOLO  U30USD
@PERIODO  M5
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
@FRAZIONEIS {frazione}
"""

FAM = {
  "L": dict(short="0", frazione="0.40",
            famiglia="L = SOLO LONG, la cella viva (InpAllowShort=0). Taglio IS/OOS 0.40,\n#            lo stesso delle corse gia' misurate r6/r35/r46b/r47/ptc.",
            nota=("#    Famiglia L: SOLO LONG, come la sedia viva 770202 in campo.\n"
                  "#    ATTESA DICHIARATA PRIMA DEI NUMERI: su questa famiglia il campione\n"
                  "#    NON raggiunge il pavimento dei 150 (misurato su mode RETEST: IS 74,\n"
                  "#    OOS 130). Quindi il MERITO qui e' SOSPESO per campione, e il round\n"
                  "#    lo sa in partenza. Il RISCHIO no: un DD accaduto vale a qualunque n.\n")),
  "B": dict(short="1", frazione="0.50",
            famiglia="B = DUE LATI (InpAllowShort=1), regola dei due lati del 25/08.\n#            Taglio IS/OOS 0.50 per portare ENTRAMBE le meta' sopra 150.",
            nota=("#    Famiglia B: DUE LATI. Serve a due cose insieme: la REGOLA DEI DUE LATI\n"
                  "#    (25/08: ogni analisi misura long E short, anche se in campo gira un\n"
                  "#    lato solo) e il PAVIMENTO DEI 150. Misurato su mode RETEST a taglio\n"
                  "#    0.40: IS 147 / OOS 203 = 350 operazioni totali; a taglio 0.50 le due\n"
                  "#    meta' valgono ~175 e ~175, cioe' SOPRA il pavimento tutte e due.\n")),
}

MODI = {
  0: dict(sigla="stop",     titolo="MODALITA' 0: BUY/SELL STOP oltre il livello + buffer",
          desc=("#    Ordine STOP oltre l'estremo del range di apertura (35 min) + 1000 punti\n"
                "#    di buffer. E' lo stile che la sedia viva del Dow NON usa.\n"
                "#    Costo dichiarato: SLIPPAGE. Si riempie sempre, spesso peggio del\n"
                "#    prezzo -- e qui lo slippage e' a ZERO, quindi questa cella e'\n"
                "#    AVVANTAGGIATA. Se vince, la vittoria ha l'asterisco (criteri par.7).")),
  1: dict(sigla="limit",    titolo="MODALITA' 1: LIMIT sul RETEST del livello rotto",
          desc=("#    *** E' LO STILE DELLA SEDIA VIVA 770202 ***  (nell'EA vivo si chiama\n"
                "#    InpEntryMode=2 = ABTG_RETEST; qui, nell'EA del duello, la stessa cosa\n"
                "#    si chiama InpEntryMode=1. I due enum NON hanno la stessa numerazione:\n"
                "#    e' la trappola numero uno di questo round, ed e' scritta nei criteri.)\n"
                "#    Offset del limit: 400 punti, valore della cella viva.\n"
                "#    Costo dichiarato: NO-FILL. Se il prezzo non torna, non si entra.\n"
                "#    DOPPIO RUOLO: e' anche il CANARINO (b), da confrontare con R180uV.")),
  2: dict(sigla="conferma", titolo="MODALITA' 2: MARKET alla CHIUSURA di una candela oltre il livello",
          desc=("#    CODICE NUOVO di R83 (ABTG_CLOSECONFIRM). NON e' l'OPENCONFIRM del\n"
                "#    motore vivo, che guarda l'APERTURA della candela: qui si pretende la\n"
                "#    CHIUSURA. Su U30USD non e' MAI girato (censimento meccanico: zero\n"
                "#    righe con questo motore su U30USD in tutto il repo).\n"
                "#    TF della conferma: InpOCTimeframe=0 = PERIOD_CURRENT = M5, il TF del\n"
                "#    grafico di questo round. NON si spazzola.\n"
                "#    Costo dichiarato: RITARDO. Si entra una candela dopo, piu' lontano dal\n"
                "#    livello; con lo stop sull'estremo opposto la distanza e' maggiore e il\n"
                "#    lotto, a parita' di rischio, minore.")),
}

MAGIC = {("L",0):777410, ("L",1):777420, ("L",2):777430,
         ("B",0):777440, ("B",1):777450, ("B",2):777460}


def scrivi(fam, modo):
    f = FAM[fam]; m = MODI[modo]
    suff = "" if fam == "L" else "b"
    nome = "R180u{}{}_{}_U30USD.txt".format(modo, suff, m["sigla"])
    etich = "r180u{}{}".format(modo, suff)
    mg = MAGIC[(fam, modo)]
    testo = CAPPELLO.format(
        titolo=m["titolo"], famiglia=f["famiglia"], nome=nome, etichetta=etich,
        descrizione=m["desc"] + "\n#\n" + f["nota"].rstrip("\n"), frazione=f["frazione"])
    righe = [testo, ""]
    for commento, coppie in CORPO:
        righe.append("# " + commento)
        for k, v in coppie:
            if v == "@ENTRY@": v = str(modo)
            if v == "@SHORT@": v = f["short"]
            righe.append("{}={}||{}||0||{}||N".format(k, v, v, v))
        righe.append("")
    righe.append("# --- L'UNICO ASSE SPAZZOLATO: due passate gemelle di controllo.")
    righe.append("#     Devono uscire IDENTICHE. Se non lo sono c'e' di mezzo la cache del")
    righe.append("#     tester o una griglia ricordata da MT5, e il numero non si legge.")
    righe.append("#     I due magic sono VERGINI: verificato con")
    righe.append("#       grep -rIl --exclude-dir=.git -w \"{}\" .   ->  0 file".format(mg))
    righe.append("#       grep -rIl --exclude-dir=.git -w \"{}\" .   ->  0 file".format(mg + 1))
    righe.append("InpMagic={}||{}||1||{}||Y".format(mg, mg, mg + 1))
    open(os.path.join(QUI, nome), "w").write("\n".join(righe) + "\n")
    return nome


if __name__ == "__main__":
    for fam in ("L", "B"):
        for modo in (0, 1, 2):
            print("scritto", scrivi(fam, modo))
