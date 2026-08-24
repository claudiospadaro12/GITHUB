#!/usr/bin/env python3
# =====================================================================
#  Generatore dei 40 file prova di R103 -- LA CLASSIFICA DELLA FLOTTA.
#
#  I nomi e i default degli input sono LETTI DAL SORGENTE di ogni EA:
#  non sono scritti a memoria (stessa macchina di R100/R102).
#
#  LE TRE DIFFERENZE DICHIARATE rispetto a R102:
#
#  1. LE SEDIE SONO 40 E STANNO IN DUE GRUPPI CON FINESTRE DIVERSE:
#       FOREX+METALLI (25) -> 2020.01.01 -> 2026.06.30  (6,5 anni)
#       INDICI        (15) -> 2024.09.26 -> 2026.06.30  (21 mesi)
#     La seconda non e' una scelta: e' il muro MISURATO del broker
#     (sonda 17/08: prima data 2024.09.26 con verdetto COMPLETO, cioe'
#     "non manca sul disco, IL BROKER NON CE L'HA").
#     Quindi @DAQUANDO qui NON e' la data di inizio storico del simbolo
#     (come in R102): e' L'INIZIO DELLA FINESTRA DEL GRUPPO.
#
#  2. DOVE ESISTE UN PRESET .set DELLA SEDIA VIVA, LA CELLA SI LEGGE DA
#     QUELLO, riga per riga, invece che da un dizionario trascritto a
#     mano dallo script di deploy. Sono artefatti che stanno nel repo
#     (mql5/Presets/sedie_piccolo/ e .../recupero2/) e sono la copia
#     piu' vicina a cio' che gira davvero. Per le sedie senza preset si
#     usa lo script di DEPLOY che le ha create, come faceva R102.
#     Il generatore stampa, sedia per sedia, QUANTI valori della cella
#     coincidono col default del sorgente: serve a vedere se un preset
#     e' davvero una cella o solo una copia dei default.
#
#  3. TRE SEDIE NON HANNO TUTTI GLI INPUT DI SERVIZIO, ed e' MISURATO
#     nei sorgenti, non supposto:
#       - ABTG_DAX_Apertura_EU  e  ABTG_Dow_Apertura_US: NESSUN
#         InpComment (infatti nel censimento .chr il loro commento e'
#         VUOTO). Il file prova non lo scrive e il driver non lo gata.
#       - Gold_Ichimoku_TK_ATR_EA: nessun InpComment, nessun InpVerbose,
#         NESSUN OnTesterDeinit (quindi NESSUN OptResults) e nessuna
#         riga di log d'ingresso. E' la sedia PROBLEMATICA del round:
#         gira SOLO la passata singola e i suoi numeri escono dai DEAL
#         del report .htm. Sta scritto nei criteri par. 7.
#
#  NON tocca nessun sorgente EA: legge e basta.
# =====================================================================
import re, os, sys

REPO = "/home/user/GITHUB"
EXP  = os.path.join(REPO, "mql5", "Experts")
PRE  = os.path.join(REPO, "mql5", "Presets")
OUT  = os.path.join(REPO, "backtest_pipeline", "prove")

TF = {"PERIOD_M1":1,"PERIOD_M2":2,"PERIOD_M3":3,"PERIOD_M4":4,"PERIOD_M5":5,
      "PERIOD_M6":6,"PERIOD_M10":10,"PERIOD_M12":12,"PERIOD_M15":15,"PERIOD_M20":20,
      "PERIOD_M30":30,"PERIOD_H1":16385,"PERIOD_H2":16386,"PERIOD_H3":16387,
      "PERIOD_H4":16388,"PERIOD_H6":16390,"PERIOD_H8":16392,"PERIOD_H12":16396,
      "PERIOD_D1":16408,"PERIOD_W1":32769,"PERIOD_MN1":49153,"PERIOD_CURRENT":0}

TFNUM = {"M5":5,"M15":15,"H1":16385,"H2":16386,"H4":16388,"D1":16408}


def enum_map(src):
    """Tutti gli enum definiti nel sorgente -> valore numerico.

    >>> DIFFERENZA DA R100/R102, ed e' un difetto che questi due
        generatori avevano e che qui MORDE: dentro un blocco enum ci
        possono stare i COMMENTI ('DIR_SHORT_ONLY = 2 // Solo SHORT'),
        e con loro int() esplode. Succede su Gold_Ichimoku_TK_ATR_EA,
        che non e' della famiglia ABTG. I commenti si tolgono PRIMA.
    """
    m = dict(TF)
    for blk in re.finditer(r'enum\s+\w+\s*\{([^}]*)\}', src):
        val = 0
        corpo = re.sub(r'//[^\n]*', '', blk.group(1))
        for tok in corpo.split(','):
            tok = tok.strip()
            if not tok:
                continue
            if '=' in tok:
                nome, v = tok.split('=', 1)
                val = int(v.strip())
                m[nome.strip()] = val
            else:
                m[tok] = val
            val += 1
    return m


def define_map(src):
    """I #define del sorgente -> valore, LA PRIMA definizione vince.

    >>> SERVE DAVVERO, e R100/R102 non ne avevano bisogno perche' nessun
        loro EA lo faceva: le due APERTURE (DAX/Dow) scrivono i default
        come MACRO ('input int InpSessionHour = ABTG_DEF_SESSION_HOUR;').
        Senza risolverle il file prova conterrebbe la riga
        'InpSessionHour=ABTG_DEF_SESSION_HOUR||...', che nel .ini non e'
        un numero: il tester la ignorerebbe in silenzio e girerebbe con
        l'ORA SBAGLIATA -- cioe' con un'altra sedia.
        LA PRIMA definizione vince perche' la seconda sta dentro un
        #ifndef (il file .mq5 sovrascrive i default dell'include).
    """
    m = {}
    for riga in src.split("\n"):
        mm = re.match(r'\s*#define\s+(\w+)\s+(.+)$', riga)
        if mm:
            nome = mm.group(1)
            if nome in m:
                continue
            m[nome] = re.sub(r'//.*$', '', mm.group(2)).strip()
    return m


def risolvi(val, em, dm, ea, nome):
    """Riduce un default a un valore SCRIVIBILE in un .ini.

    Toglie i cast ('(ENUM_ABTG_RANGE)ABTG_DEF_RANGE_MODE'), poi segue le
    macro e gli enum. Se dopo cinque giri non e' ne' un numero, ne' un
    bool, ne' una stringa fra virgolette, SI FERMA: un default non
    risolto in un file prova e' un input che il tester non applica.
    """
    for _ in range(6):
        v = val.strip()
        v2 = re.sub(r'^\(\s*\w+\s*\)\s*', '', v)
        if v2 != v:
            val = v2; continue
        if v in dm:
            val = dm[v]; continue
        if v in em:
            return str(em[v])
        return v
    print("!! %s / %s: default non risolvibile (%s)" % (ea, nome, val)); sys.exit(1)


def leggi_input(ea):
    """(nome, tipo, valore_default_normalizzato) in ORDINE DI SORGENTE."""
    src = open(os.path.join(EXP, ea + ".mq5"), encoding="utf-8", errors="replace").read()
    em = enum_map(src)
    dm = define_map(src)
    out = []
    for riga in src.split("\n"):
        r = riga.strip()
        if not r.startswith("input "):
            continue
        if r.startswith("input group"):
            continue
        r = re.sub(r'//.*$', '', r).strip().rstrip(';').strip()
        mm = re.match(r'input\s+(\S+)\s+(\w+)\s*=\s*(.+)$', r)
        if not mm:
            print("!! riga input non parsata in %s: %s" % (ea, riga)); sys.exit(1)
        tipo, nome, val = mm.group(1), mm.group(2), mm.group(3).strip()
        val = risolvi(val, em, dm, ea, nome)
        if tipo == "string":
            val = val.strip().strip('"')
        elif tipo == "bool":
            val = val.lower()
        # --- CONTROLLO POSITIVO: cio' che non e' stringa dev'essere un
        #     numero o un bool, altrimenti nel .ini non vuol dire niente.
        if tipo != "string":
            ok = val in ("true", "false")
            if not ok:
                try:
                    float(val); ok = True
                except ValueError:
                    ok = False
            if not ok:
                print("!! %s / %s: default '%s' non e' ne' numero ne' bool" % (ea, nome, val))
                sys.exit(1)
        out.append((nome, tipo, val))
    return out


def leggi_preset(rel):
    """Legge un .set della sedia viva -> dict Inp*=valore.

    CONTROLLO POSITIVO: le righe di intestazione dei preset contengono
    anch'esse degli '=' ('=== Sessione ... ===='), quindi NON si splitta
    su '=' e basta: si accetta SOLO cio' che comincia con 'Inp'. Se il
    file non produce nemmeno una riga valida ci si ferma, invece di
    tornare un dizionario vuoto che passerebbe per 'nessun override'.
    """
    path = os.path.join(PRE, rel)
    if not os.path.exists(path):
        print("!! preset assente: %s" % path); sys.exit(1)
    d, scartate = {}, 0
    for riga in open(path, encoding="utf-8", errors="replace").read().split("\n"):
        r = riga.strip()
        if not r:
            continue
        mm = re.match(r'^(Inp\w+)=(.*)$', r)
        if mm:
            d[mm.group(1)] = mm.group(2).strip()
        else:
            scartate += 1
    if not d:
        print("!! preset %s: nessuna riga Inp*= riconosciuta" % rel); sys.exit(1)
    return d, scartate


# ---------------------------------------------------------------------------
#  LE CELLE DELLE SEDIE SENZA PRESET .set NEL REPO.
#  Fonte: lo SCRIPT DI DEPLOY che le ha create (nominato sedia per sedia
#  nella tabella SEDIE). Sono gli stessi dizionari di R102, riusati
#  invariati: dove R102 e R103 misurano la stessa sedia, la cella e' la
#  STESSA (cambia solo la finestra).
# ---------------------------------------------------------------------------
BB_COMUNE   = {"InpTF":"16385","InpTPMode":"0","InpBulgeWidthMult":"1.35",
               "InpBulgeNetMoveATR":"1.0"}
GAP_COMUNE  = {"InpTF":"16385","InpGapMinATR":"0.3","InpGapMaxATR":"2.0",
               "InpSLMode":"0","InpSLGapMult":"1.0","InpMaxHours":"48",
               "InpMaxSpreadPts":"300","InpEntryWindowBars":"3"}
LARRY_COMUNE= {"InpTF":"16385","InpTP_R":"1.5","InpSLMode":"0","InpSLBufferATR":"0.1",
               "InpAtrSlMult":"1.5","InpAtrPeriodD1":"14","InpSizeMinATR":"0.0",
               "InpSizeMaxATR":"0.0","InpMaxDaysHold":"5","InpMaxSpreadPts":"300",
               "InpEntryWindowBars":"3"}
COST_COMUNE = {"InpTF":"16388","InpTP_R":"1.5","InpSLBufferATR":"0.2","InpAtrPeriod":"14",
               "InpMinRangeATR":"0.0","InpMaxBarsHold":"100","InpMaxSpreadPts":"300",
               "InpEntryWindowBars":"3","InpWarmupBars":"500",
               "InpAllowLong":"true","InpAllowShort":"false"}
EZ_COMUNE   = {"InpTF":"16385","InpPivotSource":"0","InpPivotR":"3","InpPivotL":"5",
               "InpLinRegLen":"11","InpPlotMode":"0","InpPlotLen":"11","InpCciPeriod":"20",
               "InpMaxPivotDist":"60","InpDivMaxBars":"0","InpDivDieOnFail":"false",
               "InpHourStart":"8","InpHourEnd":"18","InpPrevBars":"3",
               "InpEntryWindowBars":"3","InpMarketIfTooClose":"true","InpSLBufferPts":"30",
               "InpWarmupBars":"500","InpMaxSpreadPts":"30",
               "InpAllowLong":"true","InpAllowShort":"true"}


def u(base, extra):
    d = dict(base); d.update(extra); return d


def uguale(a, b):
    """Due valori di input sono LO STESSO VALORE?

    Confronto NUMERICO dove tutti e due sono numeri: '20.0' e '20' sono
    lo stesso ordine al broker, e chiamarli 'diversi' riempirebbe il
    referto di finte differenze di cella nascondendo quelle vere
    (checklist 47: la spia che non puo' che essere rossa).
    """
    a, b = str(a).strip(), str(b).strip()
    if a == b:
        return True
    try:
        return float(a) == float(b)
    except ValueError:
        return False


# ---------------------------------------------------------------------------
#  LE 40 SEDIE.
#
#  COLONNE, e da dove viene ognuna (criteri R103 par. 2):
#    magic_vivo / rischio / commento : MISURATI nel censimento .chr del
#        23/08/2026 15:49 (censimento_rischio_2026-08-23_1549.txt).
#        commento=None vuol dire "questo EA NON HA l'input InpComment"
#        (MISURATO nel sorgente), non "commento vuoto per pigrizia".
#    sym : dal censimento.
#    tf  : il timeframe del GRAFICO su cui la sedia gira. NON si deriva
#        da InpTF e NON si indovina: fonte dichiarata sedia per sedia.
#        >>> E' la trappola di R102: ABTG_SuperWave GBPUSD gira su un
#            grafico H4 con InpTF = H2. Derivare l'uno dall'altro
#            misurerebbe UN'ALTRA SEDIA.
#    ovr / preset : la cella viva.
#    gruppo : FOREX (finestra 2020.01.01) o INDICI (2024.09.26).
#    base : la base dei magic VERGINI 76xxxx (760000 + indice*10).
# ---------------------------------------------------------------------------
FOREX_DA  = "2020.01.01"
INDICI_DA = "2024.09.26"

SEDIE = [
 # ================= GRUPPO FOREX + METALLI (25) =====================
 dict(id="F01", ea="ABTG_BreakingBand", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="772161", rischio="1.0", commento="BB GBPUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_GBPUSD, pattern 2 = entrambi)",
      tf_fonte="deploy_vivaio_bb.ps1 (grafico H1)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"2"})),
 dict(id="F02", ea="ABTG_BreakingBand", sym="EURUSD", tf="H1", grp="FOREX",
      magic_vivo="772162", rischio="1.0", commento="BB EURUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_EURUSD, pattern 0 = CONT)",
      tf_fonte="deploy_vivaio_bb.ps1 (grafico H1)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"0"})),
 dict(id="F03", ea="ABTG_BreakingBand", sym="AUDUSD", tf="H1", grp="FOREX",
      magic_vivo="772163", rischio="1.0", commento="BB AUDUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_AUDUSD, pattern 1 = INV)",
      tf_fonte="deploy_vivaio_bb.ps1 (grafico H1)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"1"})),

 dict(id="F04", ea="ABTG_CostToCost", sym="EURJPY", tf="H4", grp="FOREX",
      magic_vivo="772361", rischio="1.0", commento="COST EURJPY",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_EURJPY, exit 2 = flip)",
      tf_fonte="deploy_vivaio_cost.ps1 (grafico H4)",
      ovr=u(COST_COMUNE, {"InpExitMode":"2"})),
 dict(id="F05", ea="ABTG_CostToCost", sym="GBPCAD", tf="H4", grp="FOREX",
      magic_vivo="772362", rischio="1.0", commento="COST GBPCAD",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_GBPCAD, exit 1 = R-based)",
      tf_fonte="deploy_vivaio_cost.ps1 (grafico H4)",
      ovr=u(COST_COMUNE, {"InpExitMode":"1"})),
 dict(id="F06", ea="ABTG_CostToCost", sym="XAGUSD", tf="H4", grp="FOREX",
      magic_vivo="772363", rischio="1.0", commento="COST XAGUSD",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_XAGUSD, exit 0 = cost puro)",
      tf_fonte="deploy_vivaio_cost.ps1 (grafico H4)",
      ovr=u(COST_COMUNE, {"InpExitMode":"0"})),

 dict(id="F07", ea="ABTG_EasyTrend", sym="CHFJPY", tf="H1", grp="FOREX",
      magic_vivo="772421", rischio="1.0", commento="EASYTREND CHFJPY",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_CHFJPY, TP_R 1,5) + rinomina commento 19/08",
      tf_fonte="deploy_vivaio_ez.ps1 (grafico H1)",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.5"})),
 dict(id="F08", ea="ABTG_EasyTrend", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="772422", rischio="1.0", commento="EASYTREND GBPUSD",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_GBPUSD, TP_R 1,5) + rinomina commento 19/08",
      tf_fonte="deploy_vivaio_ez.ps1 (grafico H1)",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.5"})),
 dict(id="F09", ea="ABTG_EasyTrend", sym="AUDJPY", tf="H1", grp="FOREX",
      magic_vivo="772423", rischio="1.0", commento="EASYTREND AUDJPY",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_AUDJPY, TP_R 1,0) + rinomina commento 19/08",
      tf_fonte="deploy_vivaio_ez.ps1 (grafico H1)",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.0"})),

 dict(id="F10", ea="ABTG_GapFill", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="772231", rischio="1.0", commento="GAP GBPUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_GBPUSD, fill 100)",
      tf_fonte="deploy_vivaio_gap.ps1 (grafico H1)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"100"})),
 dict(id="F11", ea="ABTG_GapFill", sym="EURUSD", tf="H1", grp="FOREX",
      magic_vivo="772232", rischio="1.0", commento="GAP EURUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_EURUSD, fill 50)",
      tf_fonte="deploy_vivaio_gap.ps1 (grafico H1)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"50"})),
 dict(id="F12", ea="ABTG_GapFill", sym="AUDUSD", tf="H1", grp="FOREX",
      magic_vivo="772233", rischio="1.0", commento="GAP AUDUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_AUDUSD, fill 100)",
      tf_fonte="deploy_vivaio_gap.ps1 (grafico H1)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"100"})),

 dict(id="F13", ea="ABTG_PTE", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="771322", rischio="0.5", commento="PTE GBPUSD",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_PTE_GBPUSD_771322.set",
      tf_fonte="deploy_vivaio_r23.ps1 (grafico H1)",
      preset="sedie_piccolo/sedia_PTE_GBPUSD_771322.set"),
 dict(id="F14", ea="ABTG_PTE", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="771332", rischio="0.5", commento="PTE GBPUSD B25",
      fonte="deploy_pte_gbpusd_b25.ps1 (preset VIVAIO_PTE_GBPUSD_B25: buffer 25 / TP2 3,0 -- candidata R78)",
      tf_fonte="deploy_pte_gbpusd_b25.ps1 (grafico H1)",
      ovr={"InpTF":"16385","InpTP1_ATRmult":"0.5","InpSLbufferPips":"25.0","InpTP2_ATRmult":"3.0"}),
 dict(id="F15", ea="ABTG_PTE", sym="USDJPY", tf="H1", grp="FOREX",
      magic_vivo="771323", rischio="1.0", commento="PTE USDJPY",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_PTE_USDJPY_771323.set",
      tf_fonte="deploy_vivaio_r23.ps1 (grafico H1)",
      preset="sedie_piccolo/sedia_PTE_USDJPY_771323.set"),

 dict(id="F16", ea="ABTG_PunteLarry", sym="EURAUD", tf="H1", grp="FOREX",
      magic_vivo="772342", rischio="1.0", commento="LARRY EURAUD",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_EURAUD: punta / exit R / L+S)",
      tf_fonte="deploy_vivaio_larry.ps1 (grafico H1)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"true"})),
 dict(id="F17", ea="ABTG_PunteLarry", sym="EURCAD", tf="H1", grp="FOREX",
      magic_vivo="772346", rischio="1.0", commento="LARRY EURCAD",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_EURCAD: punta / FPO / solo L)",
      tf_fonte="deploy_vivaio_larry.ps1 (grafico H1)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"0",
                           "InpAllowLong":"true","InpAllowShort":"false"})),
 dict(id="F18", ea="ABTG_PunteLarry", sym="GBPJPY", tf="H1", grp="FOREX",
      magic_vivo="772344", rischio="1.0", commento="LARRY GBPJPY",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_GBPJPY: punta / exit R / solo L)",
      tf_fonte="deploy_vivaio_larry.ps1 (grafico H1)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"false"})),
 dict(id="F19", ea="ABTG_PunteLarry", sym="GBPUSD", tf="H1", grp="FOREX",
      magic_vivo="772345", rischio="1.0", commento="LARRY GBPUSD",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_GBPUSD: libro / FPO / solo S)",
      tf_fonte="deploy_vivaio_larry.ps1 (grafico H1)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"0","InpExitMode":"0",
                           "InpAllowLong":"false","InpAllowShort":"true"})),
 dict(id="F20", ea="ABTG_PunteLarry", sym="XAUUSD", tf="H1", grp="FOREX",
      magic_vivo="772343", rischio="0.3", commento="LARRY ORO",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_ORO: libro / exit R / solo L) -- stessa cella misurata in R100 (S03)",
      tf_fonte="deploy_vivaio_larry.ps1 (grafico H1); R100 prova S03",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"0","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"false"})),

 dict(id="F21", ea="ABTG_SuperWave", sym="GBPUSD", tf="H4", grp="FOREX",
      magic_vivo="770532", rischio="1.0", commento="SW GBPUSD H2",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_SW_GBPUSD_H2_770532.set",
      tf_fonte="deploy_vivaio_r23.ps1: 'ABTG_SuperWave su GBPUSD H4 -- InpTF resta H2!' (grafico H4, InpTF H2)",
      preset="sedie_piccolo/sedia_SW_GBPUSD_H2_770532.set"),

 dict(id="F22", ea="ABTG_EMA200_Ottimizzato", sym="XAUUSD", tf="H4", grp="FOREX",
      magic_vivo="971501", rischio="0.25", commento="EMA200 OTT",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_EMA200_Ottimizzato_971501.set (stessa cella di R100 S01)",
      tf_fonte="preset InpTF=16388 + R100 prova S01 (grafico H4)",
      preset="sedie_piccolo/recupero2/sedia_ABTG_EMA200_Ottimizzato_971501.set"),
 dict(id="F23", ea="ABTG_MaxMinNotte", sym="XAUUSD", tf="H2", grp="FOREX",
      magic_vivo="770402", rischio="0.5", commento="MAXMIN ORO",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set (stessa cella di R100 S02)",
      tf_fonte="R100 prova S02 (grafico H2); il preset pinna InpMgmtTF=16386",
      preset="sedie_piccolo/sedia_MAXMIN_ORO_770402.set"),
 dict(id="F24", ea="ABTG_SupertrendReversal_Ottimizzato", sym="XAUUSD", tf="H4", grp="FOREX",
      magic_vivo="970901", rischio="1.0", commento="STREV OTT",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_SupertrendReversal_Ottimizzato_970901.set (stessa cella di R99)",
      tf_fonte="preset InpTF=16388 + prova R99_ORO_22ANNI_RISCHIO.txt (grafico H4)",
      preset="sedie_piccolo/recupero2/sedia_ABTG_SupertrendReversal_Ottimizzato_970901.set"),
 dict(id="F25", ea="Gold_Ichimoku_TK_ATR_EA", sym="XAUUSD", tf="H1", grp="FOREX",
      magic_vivo="250604", rischio="0.5", commento=None,
      fonte="DEFAULT DEL SORGENTE: nel censimento .chr magic (250604) e rischio (0,5) coincidono col default, e non esiste nessun preset di questa sedia nel repo",
      tf_fonte="il sorgente stesso: OnInit stampa 'AVVISO: l'EA e' tarato su H1' se _Period != PERIOD_H1  [DA CONFERMARE col .chr: il censimento non riporta il TF del grafico]",
      ovr={}),

 # ===================== GRUPPO INDICI (15) ==========================
 dict(id="I01", ea="ABTG_DAX_Apertura_EU", sym="D30EUR", tf="M5", grp="INDICI",
      magic_vivo="770101", rischio="0.65", commento=None,
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_DAX_Apertura_EU_770101.set (la stessa cella del metro di R101)",
      tf_fonte="report/DEPLOY_GUARDIANO_100K.md riga 149 (D30EUR M5) + R101_DAX_00_viva.txt",
      preset="sedie_piccolo/recupero2/sedia_ABTG_DAX_Apertura_EU_770101.set"),
 dict(id="I02", ea="ABTG_Dow_Apertura_US", sym="U30USD", tf="M5", grp="INDICI",
      magic_vivo="770202", rischio="0.65", commento=None,
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_Dow_Apertura_US_770202.set (la stessa cella del metro di R101)",
      tf_fonte="report/DEPLOY_GUARDIANO_100K.md riga 150 (U30USD M5) + R101_DOW_00_viva.txt",
      preset="sedie_piccolo/recupero2/sedia_ABTG_Dow_Apertura_US_770202.set"),
 dict(id="I03", ea="ABTG_EMA200", sym="U30USD", tf="H1", grp="INDICI",
      magic_vivo="771531", rischio="1.0", commento="EMA200 DOW",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_EMA200_771531.set (cella CENTRO del WF R29)",
      tf_fonte="deploy_vivaio_ema200.ps1: 'ABTG_EMA200 su U30USD H1'",
      preset="sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set"),
 dict(id="I04", ea="ABTG_GapFill", sym="U30USD", tf="H1", grp="INDICI",
      magic_vivo="772234", rischio="1.0", commento="GAP DOW",
      fonte="deploy_vivaio_gap2.ps1 (preset VIVAIO_GAP_DOW, fill 100)",
      tf_fonte="deploy_vivaio_gap2.ps1: 'U30USD H1'",
      ovr=u(GAP_COMUNE, {"InpFillPct":"100"})),
 dict(id="I05", ea="ABTG_GapFill", sym="225JPY", tf="H1", grp="INDICI",
      magic_vivo="772235", rischio="1.0", commento="GAP NIKKEI",
      fonte="deploy_vivaio_gap2.ps1 (preset VIVAIO_GAP_NIKKEI, fill 75 -- NON 100: col 100 in OOS faceva -74)",
      tf_fonte="deploy_vivaio_gap2.ps1: '225JPY H1'",
      ovr=u(GAP_COMUNE, {"InpFillPct":"75"})),
 dict(id="I06", ea="ABTG_MaxMinNotte_DAX_Short_Ottimizzato", sym="D30EUR", tf="M15", grp="INDICI",
      magic_vivo="770411", rischio="0.65", commento="MAXMIN DAX SHORT",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set (lo stesso usato da R104)",
      tf_fonte="report/DEPLOY_GUARDIANO_100K.md riga 151 (D30EUR M15) + prova R104",
      preset="sedie_piccolo/recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set"),
 dict(id="I07", ea="ABTG_ORB_Ottimizzato", sym="U30USD", tf="M5", grp="INDICI",
      magic_vivo="770611", rischio="0.3", commento="ORB OTT",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set",
      tf_fonte="report/DEPLOY_GUARDIANO_100K.md riga 153 (U30USD M5)",
      preset="sedie_piccolo/recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set"),
 dict(id="I08", ea="ABTG_PTE", sym="U30USD", tf="H1", grp="INDICI",
      magic_vivo="771321", rischio="1.0", commento="PTE DOW",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_PTE_DOW_771321.set",
      tf_fonte="deploy_vivaio_r23.ps1: 'ABTG_PTE su U30USD H1'",
      preset="sedie_piccolo/sedia_PTE_DOW_771321.set"),
 dict(id="I09", ea="ABTG_PunteLarry", sym="U30USD", tf="H1", grp="INDICI",
      magic_vivo="772341", rischio="1.0", commento="LARRY DOW",
      fonte="deploy_vivaio_larry.ps1 (VIVAIO_LARRY_DOW: punta / exit R / L+S)",
      tf_fonte="deploy_vivaio_larry.ps1: 'U30USD H1'",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"true"})),
 dict(id="I10", ea="ABTG_SupRev_DAX_H4_Ottimizzato", sym="D30EUR", tf="H4", grp="INDICI",
      magic_vivo="970912", rischio="1.0", commento="STREV DAX H4",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_SupRev_DAX_H4_Ottimizzato_970912.set",
      tf_fonte="preset InpTF=16388 + FLOTTA_ATTIVA.md riga D30EURH4",
      preset="sedie_piccolo/recupero2/sedia_ABTG_SupRev_DAX_H4_Ottimizzato_970912.set"),
 dict(id="I11", ea="ABTG_SupRev_NAS_H1_Ottimizzato", sym="NASUSD", tf="H1", grp="INDICI",
      magic_vivo="970913", rischio="1.0", commento="STREV NAS H1",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_SupRev_NAS_H1_Ottimizzato_970913.set",
      tf_fonte="preset InpTF=16385 + FLOTTA_ATTIVA.md riga NASUSDH1",
      preset="sedie_piccolo/recupero2/sedia_ABTG_SupRev_NAS_H1_Ottimizzato_970913.set"),
 dict(id="I12", ea="ABTG_SuperWave", sym="U30USD", tf="H4", grp="INDICI",
      magic_vivo="770531", rischio="1.0", commento="SW DOW H2",
      fonte="PRESET LIVE mql5/Presets/sedie_piccolo/sedia_SW_DOW_H2_770531.set",
      tf_fonte="deploy_vivaio_r23.ps1: 'ABTG_SuperWave su U30USD H4 -- InpTF resta H2!' (grafico H4, InpTF H2)",
      preset="sedie_piccolo/sedia_SW_DOW_H2_770531.set"),
 dict(id="I13", ea="ABTG_SuperWave_DOW_H1_Ottimizzato", sym="U30USD", tf="H1", grp="INDICI",
      magic_vivo="770511", rischio="1.0", commento="SUPERWAVE DOW H1",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set",
      tf_fonte="preset InpTF=16385 + FLOTTA_ATTIVA.md riga U30USDH12",
      preset="sedie_piccolo/recupero2/sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set"),
 dict(id="I14", ea="ABTG_SupertrendReversal", sym="225JPY", tf="H2", grp="INDICI",
      magic_vivo="770901", rischio="0.65", commento="STREV",
      fonte="report/DEPLOY_GUARDIANO_100K.md riga 152: '225JPY H2, InpTF 2H, long+short, TP_RR 2.0, magic 770901' (cella H2 di R5). Tutto il resto: default del sorgente",
      tf_fonte="report/DEPLOY_GUARDIANO_100K.md riga 152 (225JPY H2)",
      ovr={"InpTF":"16386"}),
 dict(id="I15", ea="ABTG_SupertrendReversal", sym="225JPY", tf="H4", grp="INDICI",
      magic_vivo="770924", rischio="1.0", commento="STREV FW Nik",
      fonte="PRESET LIVE .../recupero2/sedia_ABTG_SupertrendReversal_770924.set",
      tf_fonte="FLOTTA_ATTIVA.md riga 225JPYH4 = 770924 (grafico H4, InpTF H2 nel preset)",
      preset="sedie_piccolo/recupero2/sedia_ABTG_SupertrendReversal_770924.set"),
]

INTESTAZIONE = """# =====================================================================
#  R103 -- {id}: {ea} su {sym} {tf}
#  LA CLASSIFICA DELLA FLOTTA -- gruppo {grp}
#  Finestra: {da} -> 2026.06.30   ({durata})
#  Criteri: backtest_pipeline\\risultati_archivio\\R103_CRITERI.md
#  Proposta FIRMATA da Claudio il 24/08/2026 ("FIRMO TUTTE E TRE,
#  PARTIAMO") + chiarimento della stessa mattina: la SPINA DORSALE
#  periodo per periodo e' OBBLIGATORIA per tutte e 40 le sedie.
# ---------------------------------------------------------------------
#  QUESTO FILE E' L'ARTEFATTO CHE GIRA. I nomi degli input NON sono
#  scritti a memoria: sono stati LETTI dal sorgente
#  mql5/Experts/{ea}.mq5 e trascritti in ordine.
#  Il driver li rilegge e li conta prima di lanciare.
#
#  LA CELLA VIVA -- fonte MISURATA:
#    rischio{commfonte} : censimento .chr del 23/08/2026 15:49
#                         (censimento_rischio_2026-08-23_1549.txt)
#    gli input di cella : {fonte}
#    il TF del GRAFICO  : {tf_fonte}
#    tutto il resto     : default del sorgente al pin  [DA CONFERMARE]
#
#  >>> IL TF DEL GRAFICO NON SI DERIVA DA InpTF, E VICEVERSA. E' la
#      trappola pagata in R102: ABTG_SuperWave GBPUSD gira su un grafico
#      H4 con InpTF = H2. Qui il TF del grafico ha una FONTE SUA,
#      scritta qui sopra, sedia per sedia.
#
#  LA FINESTRA: {da} -> 2026.06.30, ed e' quella del GRUPPO
#  {grp}, non del simbolo (differenza dichiarata rispetto a R102, dove
#  @DAQUANDO era la data di inizio storico del simbolo).
{notafin}
#
#  I NUMERI CHE QUESTO FILE DEVE PRODURRE (criteri R103 par. 4):
#    A. PROFITTO ALLA TAGLIA VIVA ({risk}%) -- quello che avrebbe fatto
#       sul conto, su questo banco
#    B. PROFITTO NORMALIZZATO A 1% = A x (1 / {risk})
#       [APPROSSIMATO lineare, convenzione CONTRATTI_SEDIE.md punto 2]
#       >>> E' LA COLONNA SU CUI LA CLASSIFICA E' ORDINATA: confronta i
#           MOTORI, non le taglie.
#    C. PF, DD massimo, n operazioni, PEGGIOR GIORNATA
#    D. LA SPINA DORSALE {granul}: {colonne}
#       >>> e da li' la colonna {colneg}, che
#           e' la domanda letterale di Claudio del 24/08:
#           "vorrei capire se esistono anni negativi x qualcuno".
#
#  >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO.
#      Emendamento regola B (16/08). Una classifica e' un'informazione
#      per decidere, non un verdetto automatico.
#  MODELLO OHLC M1 dichiarato: il DD che esce e' un LIMITE INFERIORE del
#  rischio; il profitto e' una STIMA DEL LORDO (spread corrente, nessuno
#  slippage, riempimenti ideali) -- MAI un guadagno.
{notamod}
#
#  LA CELLA, campo per campo:
{cella}
# =====================================================================

@SIMBOLO  {sym}
@PERIODO  {tf}
@DAQUANDO {da}

"""

NOTA_ICHIMOKU = """#
#  >>> ATTENZIONE, QUESTA SEDIA E' DIVERSA DALLE ALTRE 39 (criteri par. 7).
#      Gold_Ichimoku_TK_ATR_EA NON HA:
#        - OnTesterDeinit, quindi NESSUN OptResults: il driver NON puo'
#          leggere ne' PF ne' DD dallo strumento delle altre sedie, e le
#          due passate GEMELLE di controllo NON GIRANO;
#        - InpComment e InpVerbose (per questo non li trovi qui sotto);
#        - nessuna riga di log d'ingresso: il GATE 1 (prima operazione)
#          si misura SOLO dal report.
#      >>> I suoi numeri escono TUTTI dai DEAL del report .htm della
#          passata singola: n, netto, spina dorsale, peggior giornata,
#          PF e un DD calcolato SUL SALDO CHIUSO (non sull'equity, che
#          e' un'altra cosa e sta piu' in basso).
#      >>> NON e' un difetto della sedia: e' che questo EA non e' della
#          famiglia ABTG e non ha la strumentazione di casa. Il referto
#          lo scrive su ogni sua riga."""

NOTA_INDICI = """#
#  >>> 21 MESI, UN SOLO REGIME, NON CONFRONTABILE con le sedie a 6,5
#      anni. Non e' una scelta: la sonda del 17/08 misura su tutti gli
#      indici prima data 2024.09.26 con verdetto COMPLETO -- cioe' non
#      manca sul disco, IL BROKER NON CE L'HA."""


righe_finali, visti_magic, problemi = {}, set(), []

for idx, s in enumerate(SEDIE, start=1):
    s["base"] = 760000 + idx * 10
    da = FOREX_DA if s["grp"] == "FOREX" else INDICI_DA
    durata = "6,5 anni" if s["grp"] == "FOREX" else "21 mesi"
    inputs = leggi_input(s["ea"])
    nomi = [n for n, t, v in inputs]
    default = dict((n, v) for n, t, v in inputs)

    # --- la cella: dal PRESET dove c'e', dallo script di deploy altrove
    scartate = 0
    if "preset" in s:
        ovr, scartate = leggi_preset(s["preset"])
        # InpMagic del preset e' il magic VIVO: qui non serve, lo scrive
        # il generatore come coppia gemella vergine.
        ovr.pop("InpMagic", None)
    else:
        ovr = dict(s["ovr"])

    # --- CONTROLLI POSITIVI: ogni override deve esistere nel sorgente
    for k in list(ovr.keys()):
        if k not in nomi:
            problemi.append("%s: '%s' della cella NON esiste fra gli input di %s" % (s["id"], k, s["ea"]))
    for obb in ("InpMagic", "InpRiskPercent"):
        if obb not in nomi:
            print("!! %s: manca %s in %s" % (s["id"], obb, s["ea"])); sys.exit(1)
    ha_comm = "InpComment" in nomi
    ha_verb = "InpVerbose" in nomi
    if (s["commento"] is not None) != ha_comm:
        problemi.append("%s: commento dichiarato=%s ma InpComment nel sorgente=%s"
                        % (s["id"], s["commento"], ha_comm))

    magic = s["base"] + 10
    if magic in visti_magic:
        print("!! %s: magic base %d duplicato" % (s["id"], magic)); sys.exit(1)
    visti_magic.add(magic)

    corpo, cella_txt, npar, uguali, diff = [], [], 0, 0, []
    for nome, tipo, val in inputs:
        fonte = "default sorgente"
        if nome in ovr:
            if uguale(ovr[nome], val):
                uguali += 1
                fonte = "cella viva (= al default del sorgente)"
            else:
                fonte = "CELLA VIVA (artefatto della sedia)"
                diff.append("%s: default %s -> cella %s" % (nome, val, ovr[nome]))
            val = ovr[nome]
        if nome == "InpRiskPercent":
            val = s["rischio"]; fonte = "TAGLIA VIVA (censimento .chr 23/08 15:49)"
        if nome == "InpComment":
            val = s["commento"]; fonte = "commento vivo (censimento .chr 23/08 15:49)"
        if nome == "InpVerbose":
            val = "true"; fonte = "serve al gate 1 (log della passata singola)"
        npar += 1
        if nome == "InpMagic":
            corpo.append("InpMagic=%d||%d||1||%d||Y" % (magic, magic, magic + 1))
            cella_txt.append("#    %-22s %-16s coppia VERGINE 76xxxx (asse Y, gemelle)"
                             % (nome, "%d/%d" % (magic, magic + 1)))
        elif tipo == "string":
            corpo.append("%s=%s" % (nome, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, "'" + str(val) + "'", fonte))
        else:
            corpo.append("%s=%s||%s||0||%s||N" % (nome, val, val, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, val, fonte))

    notafin = NOTA_INDICI if s["grp"] == "INDICI" else ""
    notamod = NOTA_ICHIMOKU if s["ea"] == "Gold_Ichimoku_TK_ATR_EA" else ""
    if s["grp"] == "FOREX":
        granul  = "ANNO PER ANNO"
        colonne = "anno | n operazioni | netto EUR | cumulato"
        colneg  = "ANNI NEGATIVI / ANNI OPERATI"
    else:
        granul  = "TRIMESTRE PER TRIMESTRE"
        colonne = "trimestre | n operazioni | netto EUR | cumulato (+ il mese per mese, come DIAGNOSTICA)"
        colneg  = "TRIMESTRI NEGATIVI / TRIMESTRI OPERATI"

    testo = INTESTAZIONE.format(
        id=s["id"], ea=s["ea"], sym=s["sym"], tf=s["tf"], grp=s["grp"], da=da,
        durata=durata, fonte=s["fonte"], tf_fonte=s["tf_fonte"], risk=s["rischio"],
        commfonte=" e commento" if ha_comm else "            ",
        granul=granul, colonne=colonne, colneg=colneg,
        notafin=notafin, notamod=notamod, cella="\n".join(cella_txt))
    testo += "\n".join(corpo) + "\n"

    fn = os.path.join(OUT, "R103_%s_%s_%s.txt" % (s["ea"], s["sym"], s["magic_vivo"]))
    open(fn, "w", encoding="utf-8").write(testo)

    vive = 3 + npar
    righe_finali[s["id"]] = dict(ea=s["ea"], sym=s["sym"], magic=s["magic_vivo"], tf=s["tf"],
                                 da=da, npar=npar, vive=vive, base=s["base"],
                                 ma=magic, mb=magic + 1, grp=s["grp"], risk=s["rischio"],
                                 comm=s["commento"], verb=ha_verb, uguali=uguali,
                                 nOvr=len(ovr), scartate=scartate, diff=diff)
    print("%s %-6s %-38s %-7s TF %-3s da %s  par %3d  vive %3d  magic %d/%d/%d  cella %2d (%d = default)%s"
          % (s["id"], s["grp"], s["ea"], s["sym"], s["tf"], da, npar, vive,
             magic, magic + 1, magic + 2, len(ovr), uguali,
             "" if ha_verb else "   <<< SENZA InpVerbose"))
    for d in diff:
        print("        cella != default:  " + d)

print()
if problemi:
    print("!!! PROBLEMI (nessun file e' da fidarsi finche' non sono chiusi):")
    for p in problemi:
        print("   - " + p)
    sys.exit(1)
print("nessun problema: 40/40 celle verificate contro gli input dei sorgenti veri.")

print()
print("--- TABELLA PER IL DRIVER ($SEDIE) ---")
for s in SEDIE:
    r = righe_finali[s["id"]]
    comm = r["comm"] if r["comm"] is not None else ""
    print('  (S "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s" %d %d %d "%s"),'
          % (s["id"], r["ea"], r["sym"], r["tf"], r["grp"], r["magic"], r["risk"],
             comm, r["base"], r["npar"], r["vive"], r["da"]))

print()
print("--- SIMBOLI DISTINTI PER GRUPPO (PASSO 0-A: uno scarico per simbolo) ---")
for g in ("FOREX", "INDICI"):
    simb = {}
    for s in SEDIE:
        if s["grp"] != g:
            continue
        simb.setdefault(s["sym"], []).append(s["id"])
    print("  %s (%d simboli):" % (g, len(simb)))
    for k in sorted(simb):
        tfs = sorted(set(x["tf"] for x in SEDIE if x["sym"] == k), key=lambda t: TFNUM[t])
        print('    %-7s  TF grafico %-12s  %d sedie: %s'
              % (k, ",".join(tfs), len(simb[k]), ", ".join(simb[k])))

print()
print("--- CONTEGGI ---")
nf = len([s for s in SEDIE if s["grp"] == "FOREX"])
ni = len([s for s in SEDIE if s["grp"] == "INDICI"])
print("  sedie FOREX+METALLI: %d   sedie INDICI: %d   TOTALE: %d" % (nf, ni, nf + ni))
print("  EA distinti: %d" % len(set(s["ea"] for s in SEDIE)))
print("  magic usati: %d (da %d a %d, blocco 76xxxx)"
      % (3 * len(SEDIE), 760000 + 10 + 10, 760000 + 10 * len(SEDIE) + 12))
