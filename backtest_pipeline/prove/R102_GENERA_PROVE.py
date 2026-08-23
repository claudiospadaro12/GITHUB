#!/usr/bin/env python3
# =====================================================================
#  Generatore dei file prova R102 -- LA CLASSIFICA LUNGA.
#  I nomi e i default degli input sono LETTI DAL SORGENTE di ogni EA:
#  non sono scritti a memoria (stessa macchina di R100_GENERA_PROVE.py).
#
#  DIFFERENZA DICHIARATA rispetto a R100: qui il SIMBOLO cambia sedia per
#  sedia, e cambia con lui la data di inizio storico (@DAQUANDO), che
#  viene dalla SONDA DEL 17/08 (PrimaDataTF, colonna misurata).
#
#  E una seconda differenza, DICHIARATA perche' e' una trappola:
#  l'InpTF NON si deriva dal timeframe del grafico. Su ABTG_SuperWave
#  GBPUSD la sedia viva gira su un grafico H4 con InpTF = H2 (16386) --
#  sta scritto in deploy_vivaio_r23.ps1: "InpTF resta H2!". Derivarlo
#  dal grafico avrebbe misurato UN'ALTRA sedia.
# =====================================================================
import re, os, sys

REPO = "/home/user/GITHUB"
EXP  = os.path.join(REPO, "mql5", "Experts")
OUT  = os.path.join(REPO, "backtest_pipeline", "prove")

TF = {"PERIOD_M1":1,"PERIOD_M2":2,"PERIOD_M3":3,"PERIOD_M4":4,"PERIOD_M5":5,
      "PERIOD_M6":6,"PERIOD_M10":10,"PERIOD_M12":12,"PERIOD_M15":15,"PERIOD_M20":20,
      "PERIOD_M30":30,"PERIOD_H1":16385,"PERIOD_H2":16386,"PERIOD_H3":16387,
      "PERIOD_H4":16388,"PERIOD_H6":16390,"PERIOD_H8":16392,"PERIOD_H12":16396,
      "PERIOD_D1":16408,"PERIOD_W1":32769,"PERIOD_MN1":49153,"PERIOD_CURRENT":0}

def enum_map(src):
    """Tutti gli enum definiti nel sorgente -> valore numerico."""
    m = dict(TF)
    for blk in re.finditer(r'enum\s+\w+\s*\{([^}]*)\}', src):
        val = 0
        for tok in blk.group(1).split(','):
            tok = tok.strip()
            if not tok: continue
            if '=' in tok:
                nome, v = tok.split('=', 1)
                val = int(v.strip())
                m[nome.strip()] = val
            else:
                m[tok] = val
            val += 1
    return m

def leggi_input(ea):
    """(nome, tipo, valore_default_normalizzato) in ORDINE DI SORGENTE."""
    src = open(os.path.join(EXP, ea + ".mq5"), encoding="utf-8", errors="replace").read()
    em = enum_map(src)
    out = []
    for riga in src.split("\n"):
        r = riga.strip()
        if not r.startswith("input "): continue
        if r.startswith("input group"): continue
        r = re.sub(r'//.*$', '', r).strip().rstrip(';').strip()
        mm = re.match(r'input\s+(\S+)\s+(\w+)\s*=\s*(.+)$', r)
        if not mm:
            print("!! riga input non parsata in %s: %s" % (ea, riga)); sys.exit(1)
        tipo, nome, val = mm.group(1), mm.group(2), mm.group(3).strip()
        if tipo == "string":
            val = val.strip().strip('"')
        elif val in em:
            val = str(em[val])
        elif tipo == "bool":
            val = val.lower()
        out.append((nome, tipo, val))
    return out

# ---------------------------------------------------------------------------
#  LE DATE DI INIZIO STORICO -- MISURATE.
#  Fonte unica: backtest_pipeline/risultati_archivio/sonda_storico_17-08/
#  215D85D7_ABTG_InfoBroker.csv, colonna PrimaDataTF (TF = H1), referto
#  REFERTO_SONDA_STORICO_17-08.md. NON sono ricordate: sono trascritte.
#
#  ATTENZIONE, ED E' SCRITTO NEI CRITERI (par. 4): la sonda misura la
#  PRIMA DATA, non la DENSITA'. Una serie che comincia nel 1971 con 6.726
#  barre D1 non e' "55 anni di dati": e' una serie RADA. Chi decide
#  davvero e' il GATE 1 (prima operazione) e il GATE 4 (operazioni per
#  anno solare), non questa tabella.
# ---------------------------------------------------------------------------
SONDA = {
    "EURUSD": "1971.01.03",   # BarreD1 6820  -- EUR pre-1999: serie RICOSTRUITA
    "USDJPY": "1971.01.03",   # BarreD1 6726  -- Bretton Woods: serie RICOSTRUITA
    "CHFJPY": "1992.02.18",   # BarreD1 2907
    "GBPJPY": "1993.04.18",   # BarreD1 1429
    "AUDUSD": "1993.04.26",   # BarreD1 3610
    "EURJPY": "1993.04.26",   # BarreD1 6726  -- EUR pre-1999: serie RICOSTRUITA
    "GBPUSD": "1993.05.11",   # BarreD1 6412
    "AUDJPY": "1993.05.16",   # BarreD1 2920
    "EURCAD": "1999.08.01",   # BarreD1 2780
    "EURAUD": "2004.06.16",   # BarreD1 2988
    "GBPCAD": "2007.08.21",   # BarreD1 2850
    "XAGUSD": "2008.11.07",   # BarreD1 1326  -- il piu' corto: e' lui a legare
                              #                  la FINESTRA COMUNE al 2009
}

# ---------------------------------------------------------------------------
#  LE 20 SEDIE. 'ovr' = gli input che sulla sedia VIVA sono DIVERSI dal
#  default del sorgente, con la FONTE MISURATA (artefatto di deploy).
#
#  rischio e commento: MISURATI nel censimento .chr del 23/08/2026 15:49
#  (risultati_archivio/censimento_rischio_2026-08-23_1549.txt) -- e' il
#  censimento piu' recente che esiste, del giorno stesso. TUTTE E VENTI
#  le sedie di R102 hanno il rischio vivo MISURATO: qui non esiste il
#  GRUPPO 2 di R100 (le sedie a taglia di riferimento).
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

SEDIE = [
 # --- BREAKING BAND (la domanda esplicita di Claudio del 23/08) ---
 dict(id="C01", ea="ABTG_BreakingBand", sym="GBPUSD", tf="H1", base=790100,
      magic_vivo="772161", rischio="1.0", commento="BB GBPUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_GBPUSD)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"2"})),
 dict(id="C02", ea="ABTG_BreakingBand", sym="EURUSD", tf="H1", base=790200,
      magic_vivo="772162", rischio="1.0", commento="BB EURUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_EURUSD)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"0"})),
 dict(id="C03", ea="ABTG_BreakingBand", sym="AUDUSD", tf="H1", base=790300,
      magic_vivo="772163", rischio="1.0", commento="BB AUDUSD",
      fonte="deploy_vivaio_bb.ps1 (preset VIVAIO_BB_AUDUSD)",
      ovr=u(BB_COMUNE, {"InpPatternMode":"1"})),
 # --- PTE (il duello GBPUSD + la storica USDJPY) ---
 dict(id="C04", ea="ABTG_PTE", sym="GBPUSD", tf="H1", base=790400,
      magic_vivo="771322", rischio="0.5", commento="PTE GBPUSD",
      fonte="deploy_pte_gbpusd_b25.ps1 (preset VIVAIO_PTE_GBPUSD, rischio 0,5 dal 17/08)",
      ovr={"InpTF":"16385","InpTP1_ATRmult":"0.5","InpSLbufferPips":"5.0","InpTP2_ATRmult":"2.0"}),
 dict(id="C05", ea="ABTG_PTE", sym="GBPUSD", tf="H1", base=790500,
      magic_vivo="771332", rischio="0.5", commento="PTE GBPUSD B25",
      fonte="deploy_pte_gbpusd_b25.ps1 (preset VIVAIO_PTE_GBPUSD_B25, candidata R78)",
      ovr={"InpTF":"16385","InpTP1_ATRmult":"0.5","InpSLbufferPips":"25.0","InpTP2_ATRmult":"3.0"}),
 dict(id="C06", ea="ABTG_PTE", sym="USDJPY", tf="H1", base=790600,
      magic_vivo="771323", rischio="1.0", commento="PTE USDJPY",
      fonte="deploy_vivaio_r23.ps1 (preset VIVAIO_PTE_USDJPY)",
      ovr={"InpTF":"16385","InpTP1_ATRmult":"0.5"}),
 # --- SUPERWAVE ---
 dict(id="C07", ea="ABTG_SuperWave", sym="GBPUSD", tf="H4", base=790700,
      magic_vivo="770532", rischio="1.0", commento="SW GBPUSD H2",
      fonte="deploy_vivaio_r23.ps1 (preset VIVAIO_SW_GBPUSD -- grafico H4, InpTF H2)",
      ovr={"InpTF":"16386"}),
 # --- EASY TREND ---
 dict(id="C08", ea="ABTG_EasyTrend", sym="CHFJPY", tf="H1", base=790800,
      magic_vivo="772421", rischio="1.0", commento="EASYTREND CHFJPY",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_CHFJPY) + rinomina commento 19/08",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.5"})),
 dict(id="C09", ea="ABTG_EasyTrend", sym="GBPUSD", tf="H1", base=790900,
      magic_vivo="772422", rischio="1.0", commento="EASYTREND GBPUSD",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_GBPUSD) + rinomina commento 19/08",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.5"})),
 dict(id="C10", ea="ABTG_EasyTrend", sym="AUDJPY", tf="H1", base=791000,
      magic_vivo="772423", rischio="1.0", commento="EASYTREND AUDJPY",
      fonte="deploy_vivaio_ez.ps1 (preset VIVAIO_EZ_AUDJPY) + rinomina commento 19/08",
      ovr=u(EZ_COMUNE, {"InpTP_R":"1.0"})),
 # --- COST TO COST ---
 dict(id="C11", ea="ABTG_CostToCost", sym="EURJPY", tf="H4", base=791100,
      magic_vivo="772361", rischio="1.0", commento="COST EURJPY",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_EURJPY)",
      ovr=u(COST_COMUNE, {"InpExitMode":"2"})),
 dict(id="C12", ea="ABTG_CostToCost", sym="GBPCAD", tf="H4", base=791200,
      magic_vivo="772362", rischio="1.0", commento="COST GBPCAD",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_GBPCAD)",
      ovr=u(COST_COMUNE, {"InpExitMode":"1"})),
 dict(id="C13", ea="ABTG_CostToCost", sym="XAGUSD", tf="H4", base=791300,
      magic_vivo="772363", rischio="1.0", commento="COST XAGUSD",
      fonte="deploy_vivaio_cost.ps1 (preset VIVAIO_COST_XAGUSD)",
      ovr=u(COST_COMUNE, {"InpExitMode":"0"})),
 # --- GAP FILL ---
 dict(id="C14", ea="ABTG_GapFill", sym="GBPUSD", tf="H1", base=791400,
      magic_vivo="772231", rischio="1.0", commento="GAP GBPUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_GBPUSD)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"100"})),
 dict(id="C15", ea="ABTG_GapFill", sym="EURUSD", tf="H1", base=791500,
      magic_vivo="772232", rischio="1.0", commento="GAP EURUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_EURUSD)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"50"})),
 dict(id="C16", ea="ABTG_GapFill", sym="AUDUSD", tf="H1", base=791600,
      magic_vivo="772233", rischio="1.0", commento="GAP AUDUSD",
      fonte="deploy_vivaio_gap.ps1 (preset VIVAIO_GAP_AUDUSD)",
      ovr=u(GAP_COMUNE, {"InpFillPct":"100"})),
 # --- PUNTE LARRY (le 4 forex: DOW e' indice, ORO l'ha gia' fatto R100) ---
 dict(id="C17", ea="ABTG_PunteLarry", sym="EURAUD", tf="H1", base=791700,
      magic_vivo="772342", rischio="1.0", commento="LARRY EURAUD",
      fonte="deploy_vivaio_larry.ps1 (preset VIVAIO_LARRY_EURAUD)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"true"})),
 dict(id="C18", ea="ABTG_PunteLarry", sym="GBPJPY", tf="H1", base=791800,
      magic_vivo="772344", rischio="1.0", commento="LARRY GBPJPY",
      fonte="deploy_vivaio_larry.ps1 (preset VIVAIO_LARRY_GBPJPY)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"1",
                           "InpAllowLong":"true","InpAllowShort":"false"})),
 dict(id="C19", ea="ABTG_PunteLarry", sym="GBPUSD", tf="H1", base=791900,
      magic_vivo="772345", rischio="1.0", commento="LARRY GBPUSD",
      fonte="deploy_vivaio_larry.ps1 (preset VIVAIO_LARRY_GBPUSD)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"0","InpExitMode":"0",
                           "InpAllowLong":"false","InpAllowShort":"true"})),
 dict(id="C20", ea="ABTG_PunteLarry", sym="EURCAD", tf="H1", base=792000,
      magic_vivo="772346", rischio="1.0", commento="LARRY EURCAD",
      fonte="deploy_vivaio_larry.ps1 (preset VIVAIO_LARRY_EURCAD)",
      ovr=u(LARRY_COMUNE, {"InpPatternMode":"1","InpExitMode":"0",
                           "InpAllowLong":"true","InpAllowShort":"false"})),
]

INTESTAZIONE = """# =====================================================================
#  R102 -- {id}: {ea} su {sym} {tf}
#  LA CLASSIFICA LUNGA -- la finestra PIU' LUNGA che il broker permette
#  su questo simbolo: {da} -> 2026.06.30
#  Criteri: backtest_pipeline\\risultati_archivio\\R102_CRITERI.md
# ---------------------------------------------------------------------
#  QUESTO FILE E' L'ARTEFATTO CHE GIRA. I nomi degli input NON sono
#  scritti a memoria: sono stati LETTI dal sorgente
#  mql5/Experts/{ea}.mq5 e trascritti in ordine.
#  Il driver li rilegge e li conta prima di lanciare.
#
#  LA CELLA VIVA -- fonte MISURATA:
#    rischio e commento : censimento .chr del 23/08/2026 15:49
#                         (censimento_rischio_2026-08-23_1549.txt)
#    gli input di cella : {fonte}
#    tutto il resto     : default del sorgente al pin  [DA CONFERMARE]
#
#  LA DATA @DAQUANDO: MISURATA dalla sonda del 17/08 (PrimaDataTF su H1,
#  215D85D7_ABTG_InfoBroker.csv). NON e' una scelta e non e' un ricordo.
#
#  I NUMERI CHE QUESTO FILE DEVE PRODURRE (criteri R102 par. 3):
#    A. profitto / PF / DD / n sulla FINESTRA LUNGA -> [ROBUSTEZZA]
#    B. gli stessi sulla FINESTRA COMUNE 2009.01.01 -> 2026.06.30, che
#       e' l'UNICA colonna in cui le sedie sono confrontabili fra loro
#    C. gli stessi dentro le QUATTRO finestre di regime di casa
#    D. la PEGGIOR GIORNATA in % (muro prop giornaliero 5%) -> [RISCHIO]
#    E. la spina dorsale ANNO PER ANNO (n e netto), che e' la risposta
#       letterale alla domanda di Claudio del 23/08:
#       "con 10 anni di storico avrebbe fatto lo stesso?"
#
#  >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO.
#      Emendamento regola B (16/08): il VECCHIO giudica il RISCHIO, il
#      RECENTE giudica il MERITO. Il profitto della finestra vecchia
#      descrive la ROBUSTEZZA, non il merito della sedia.
#  MODELLO OHLC M1 dichiarato: i tick reali di BCM partono dal
#  2024.07.05, su vent'anni NON ESISTONO. Il DD che esce e' un LIMITE
#  INFERIORE del rischio; il profitto che esce e' una STIMA DEL LORDO
#  (spread corrente, nessuno slippage, riempimenti ideali) -- MAI
#  un guadagno promesso.
#
#  LA CELLA, campo per campo:
{cella}
# =====================================================================

@SIMBOLO  {sym}
@PERIODO  {tf}
@DAQUANDO {da}

"""

TFNUM = {"H1":16385,"H2":16386,"H4":16388,"D1":16408}

righe_finali = {}
visti_magic = set()
for s in SEDIE:
    if s["sym"] not in SONDA:
        print("!! %s: simbolo %s assente dalla sonda" % (s["id"], s["sym"])); sys.exit(1)
    da = SONDA[s["sym"]]
    inputs = leggi_input(s["ea"])
    nomi = [n for n, t, v in inputs]
    # --- controlli positivi: gli override devono esistere nel sorgente
    for k in s["ovr"]:
        if k not in nomi:
            print("!! %s: override '%s' NON esiste fra gli input di %s" % (s["id"], k, s["ea"])); sys.exit(1)
    for obb in ("InpMagic", "InpRiskPercent", "InpComment", "InpVerbose"):
        if obb not in nomi:
            print("!! %s: manca %s in %s" % (s["id"], obb, s["ea"])); sys.exit(1)
    magic = s["base"] + 10
    if magic in visti_magic:
        print("!! %s: magic base %d duplicato" % (s["id"], magic)); sys.exit(1)
    visti_magic.add(magic)
    corpo, cella_txt, npar = [], [], 0
    for nome, tipo, val in inputs:
        fonte = "default sorgente"
        if nome in s["ovr"]:
            val = s["ovr"][nome]; fonte = "CELLA VIVA (artefatto di deploy)"
        if nome == "InpRiskPercent":
            val = s["rischio"]; fonte = "TAGLIA VIVA (censimento .chr 23/08 15:49)"
        if nome == "InpComment":
            val = s["commento"]; fonte = "commento vivo (censimento .chr 23/08 15:49)"
        if nome == "InpVerbose":
            val = "true"; fonte = "serve al gate 1 (log della passata singola)"
        npar += 1
        if nome == "InpMagic":
            corpo.append("InpMagic=%d||%d||1||%d||Y" % (magic, magic, magic + 1))
            cella_txt.append("#    %-22s %-16s coppia VERGINE 79xxxx (asse Y, gemelle)" % (nome, "%d/%d" % (magic, magic + 1)))
        elif tipo == "string":
            corpo.append("%s=%s" % (nome, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, "'" + val + "'", fonte))
        else:
            corpo.append("%s=%s||%s||0||%s||N" % (nome, val, val, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, val, fonte))
    testo = INTESTAZIONE.format(id=s["id"], ea=s["ea"], sym=s["sym"], tf=s["tf"],
                                da=da, fonte=s["fonte"], cella="\n".join(cella_txt))
    testo += "\n".join(corpo) + "\n"
    fn = os.path.join(OUT, "R102_%s_%s_%s.txt" % (s["ea"], s["sym"], s["magic_vivo"]))
    open(fn, "w", encoding="utf-8").write(testo)
    vive = 3 + npar
    righe_finali[s["id"]] = (s["ea"], s["sym"], s["magic_vivo"], s["tf"], da, npar, vive, magic, magic + 1)
    print("%s  %-20s %-7s TF %-3s da %s  param %3d  righe vive %3d  magic %d/%d"
          % (s["id"], s["ea"], s["sym"], s["tf"], da, npar, vive, magic, magic + 1))

print()
print("--- TABELLA PER IL DRIVER ($SEDIE) ---")
for s in SEDIE:
    ea, sym, mv, tf, da, npar, vive, ma, mb = righe_finali[s["id"]]
    print('  (S "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s" %d %d %d),'
          % (s["id"], ea, sym, tf, da, mv, s["rischio"], s["commento"], s["base"], npar, vive))
print()
print("--- SIMBOLI DISTINTI (PASSO 0-A: uno scarico per simbolo, non per sedia) ---")
simb = {}
for s in SEDIE:
    simb.setdefault(s["sym"], []).append(s["id"])
for k in sorted(simb, key=lambda x: SONDA[x]):
    print('  @("%s","%s"),   # %d sedie: %s' % (k, SONDA[k], len(simb[k]), ", ".join(simb[k])))
print()
print("--- TIMEFRAME DA SCARICARE PER SIMBOLO ---")
for k in sorted(simb):
    tfs = sorted(set(SEDIE[i]["tf"] for i in range(len(SEDIE)) if SEDIE[i]["sym"] == k))
    print("  %-7s %s" % (k, ",".join(tfs)))
