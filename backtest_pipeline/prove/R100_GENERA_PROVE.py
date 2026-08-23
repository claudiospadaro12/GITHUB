#!/usr/bin/env python3
# Generatore dei file prova R100. I nomi e i default degli input sono LETTI
# DAL SORGENTE di ogni EA: non sono scritti a memoria.
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
#  LE 12 SEDIE. 'ovr' = gli input che sulla sedia VIVA sono DIVERSI dal
#  default del sorgente, con la FONTE MISURATA scritta accanto.
# ---------------------------------------------------------------------------
SEDIE = [
 dict(id="S01", ea="ABTG_EMA200_Ottimizzato", tf="H4", grp=1,
      magic_vivo="971501", rischio="1.0", commento="EMA200 OTT", base=780100, ovr={}),
 dict(id="S02", ea="ABTG_MaxMinNotte", tf="H2", grp=1,
      magic_vivo="770402", rischio="1.0", commento="MAXMIN ORO", base=780200,
      ovr={"InpBoxStartHour":"22","InpBoxStartMin":"0","InpBoxEndHour":"6","InpBoxEndMin":"59",
           "InpPlaceHour":"7","InpPlaceMin":"0","InpEntryCutoffHour":"9","InpEntryCutoffMin":"30",
           "InpBufferPoints":"250","InpSLMode":"0","InpMgmtTF":"16386","InpUseCorrelation":"false"}),
 dict(id="S03", ea="ABTG_PunteLarry", tf="H1", grp=1,
      magic_vivo="772343", rischio="1.0", commento="LARRY ORO", base=780300,
      ovr={"InpPatternMode":"0","InpExitMode":"1","InpAllowLong":"true","InpAllowShort":"false",
           "InpTF":"16385","InpTP_R":"1.5","InpSLMode":"0","InpSLBufferATR":"0.1",
           "InpAtrSlMult":"1.5","InpAtrPeriodD1":"14","InpSizeMinATR":"0.0","InpSizeMaxATR":"0.0",
           "InpMaxDaysHold":"5","InpMaxSpreadPts":"300","InpEntryWindowBars":"3"}),
 dict(id="S04", ea="ABTG_SupertrendReversal_Multi_Ottimizzato", tf="H4", grp=2,
      magic_vivo="971001", rischio="1.0", commento="STREV MULTI OTT", base=780400, ovr={}),
 dict(id="S05", ea="ABTG_GoldenCross_Ottimizzato", tf="H1", grp=2,
      magic_vivo="970301", rischio="1.0", commento="GOLDENCROSS OTT", base=780500, ovr={}),
 dict(id="S06", ea="ABTG_SupertrendReversal", tf="H4", grp=2,
      magic_vivo="770901", rischio="1.0", commento="STREV", base=780600, ovr={}),
 dict(id="S07", ea="ABTG_SupertrendReversal_Multi", tf="H4", grp=2,
      magic_vivo="771001", rischio="1.0", commento="STREV MULTI", base=780700, ovr={}),
 dict(id="S08", ea="ABTG_EMA200", tf="H4", grp=2,
      magic_vivo="771501", rischio="1.0", commento="EMA200", base=780800, ovr={}),
 dict(id="S09", ea="ABTG_GoldenCross", tf="H1", grp=2,
      magic_vivo="770301", rischio="1.0", commento="GOLDENCROSS", base=780900, ovr={}),
 dict(id="S10", ea="ABTG_SupertrendInvert", tf="H1", grp=2,
      magic_vivo="770801", rischio="1.0", commento="STINVERT", base=781000, ovr={}),
 dict(id="S11", ea="ABTG_PTE", tf="H4", grp=2,
      magic_vivo="771301", rischio="1.0", commento="PTE", base=781100, ovr={}),
 dict(id="S12", ea="ABTG_WOL", tf="D1", grp=2,
      magic_vivo="771401", rischio="1.0", commento="WOL", base=781200, ovr={}),
]

TFNUM = {"H1":16385,"H2":16386,"H4":16388,"D1":16408}

INTESTAZIONE = """# =====================================================================
#  R100 -- {id}: {ea} su XAUUSD {tf}
#  LA MISURA DEL RISCHIO DELLA FLOTTA ORO SU 22 ANNI (2004.06.11 -> 2026.06.30)
#  Criteri: backtest_pipeline\\risultati_archivio\\R100_CRITERI.md
#  -- estensione INVARIATA dei criteri FIRMATI di R99 il 23/08/2026,
#     sedia per sedia, su ordine di Claudio del 23/08 ("FAI PARTIRE R99
#     SULLE ALTRE SEDIE ORO").
# ---------------------------------------------------------------------
#  QUESTO FILE E' L'ARTEFATTO CHE GIRA. I nomi degli input NON sono
#  scritti a memoria: sono stati LETTI dal sorgente
#  mql5/Experts/{ea}.mq5 e trascritti in ordine.
#  Il driver li rilegge e li conta prima di lanciare.
#
#  GRUPPO {grp} -- {grpdesc}
#
#  LA CELLA:
{cella}
#
#  I TRE NUMERI CHE QUESTO FILE DEVE PRODURRE (criteri R99 par. 3,
#  estesi INVARIATI):
#    A. DD massimo dell'equity su 2004.06.11 -> 2026.06.30 alla taglia
#       di rischio dichiarata qui sotto
#    B. la PEGGIOR GIORNATA in %  (il muro prop giornaliero e' 5%)
#    C. il DD massimo dentro ciascuna delle QUATTRO finestre di regime
#  E UNA SOLA DECISIONE MECCANICA: DD lungo > 2x il DD promesso in
#  report/CONTRATTI_SEDIE.md -> REVISIONE (corsia RISCHIO, firma 18/08).
#
#  QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO
#  (Emendamento regola B: il VECCHIO giudica il RISCHIO).
#  MODELLO OHLC M1 dichiarato: i tick reali di BCM partono dal
#  2024.07.05, su 22 anni NON ESISTONO. Il numero che esce e' un
#  LIMITE INFERIORE del rischio, MAI UN PERMESSO.
# =====================================================================

@SIMBOLO  XAUUSD
@PERIODO  {tf}
@DAQUANDO 2004.06.11

"""

GRPDESC = {
 1: ("SEDIA CENSITA: il rischio vivo e' MISURATO nel censimento .chr del\n"
     "#  19/08/2026 15:34 (risultati_archivio/censimento_rischio_2026-08-19_1534.txt).\n"
     "#  Il DD che esce e' alla taglia VIVA della sedia."),
 2: ("SEDIA NON CENSITA: e' dichiarata viva su XAUUSD in FLOTTA_ATTIVA.md\n"
     "#  (mappa dei 52 grafici del 02/08) ma NON compare in nessuno dei sette\n"
     "#  censimenti .chr del 17-19/08, e il censimento frequenza del 22/08 le\n"
     "#  misura ZERO trade nello statement 30/03->21/08.\n"
     "#  >>> IL SUO RISCHIO VIVO NON ESISTE COME MISURA. Qui e' pinnato a 1,00%\n"
     "#      come TAGLIA DI RIFERIMENTO DICHIARATA, non come taglia viva: il\n"
     "#      numero che esce e' un DD-per-1%, riscalabile linearmente\n"
     "#      [APPROSSIMATO, convenzione CONTRATTI_SEDIE par. COME LEGGERE I\n"
     "#      NUMERI punto 2] appena un censimento .chr misurera' il rischio\n"
     "#      vero. Il verdetto della corsia RISCHIO su questa sedia resta\n"
     "#      NON MISURABILE finche' quel censimento non esiste."),
}

righe_finali = {}
for s in SEDIE:
    inputs = leggi_input(s["ea"])
    nomi = [n for n, t, v in inputs]
    # --- controlli positivi: gli override devono esistere nel sorgente
    for k in s["ovr"]:
        if k not in nomi:
            print("!! %s: override '%s' NON esiste fra gli input di %s" % (s["id"], k, s["ea"])); sys.exit(1)
    for obb in ("InpMagic", "InpRiskPercent"):
        if obb not in nomi:
            print("!! %s: manca %s in %s" % (s["id"], obb, s["ea"])); sys.exit(1)
    magic = s["base"] + 10
    corpo, cella_txt, npar = [], [], 0
    for nome, tipo, val in inputs:
        fonte = "default sorgente"
        if nome in s["ovr"]:
            val = s["ovr"][nome]; fonte = "CELLA VIVA (artefatto di deploy)"
        if nome == "InpRiskPercent":
            val = s["rischio"]; fonte = "TAGLIA PINNATA dal criterio A"
        if nome == "InpComment":
            val = s["commento"]; fonte = "commento della sedia viva"
        if nome in ("InpTF", "InpTimeframe"):
            atteso = TFNUM[s["tf"]]
            if str(val) != str(atteso):
                val = str(atteso); fonte = "allineato a @PERIODO " + s["tf"]
        if nome == "InpVerbose":
            val = "true"; fonte = "serve al gate 1 (log della passata singola)"
        npar += 1
        if nome == "InpMagic":
            corpo.append("InpMagic=%d||%d||1||%d||Y" % (magic, magic, magic + 1))
            cella_txt.append("#    %-22s %-16s coppia VERGINE 78xxxx (asse Y, gemelle)" % (nome, "%d/%d" % (magic, magic + 1)))
        elif tipo == "string":
            corpo.append("%s=%s" % (nome, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, "'" + val + "'", fonte))
        else:
            corpo.append("%s=%s||%s||0||%s||N" % (nome, val, val, val))
            cella_txt.append("#    %-22s %-16s %s" % (nome, val, fonte))
    testo = INTESTAZIONE.format(id=s["id"], ea=s["ea"], tf=s["tf"], grp=s["grp"],
                                grpdesc=GRPDESC[s["grp"]], cella="\n".join(cella_txt))
    testo += "\n".join(corpo) + "\n"
    fn = os.path.join(OUT, "R100_%s_%s.txt" % (s["ea"], s["magic_vivo"]))
    open(fn, "w", encoding="utf-8").write(testo)
    vive = 3 + npar
    righe_finali[s["id"]] = (s["ea"], s["magic_vivo"], s["tf"], npar, vive, magic, magic + 1)
    print("%s  %-45s TF %-3s param %3d  righe vive %3d  magic %d/%d  -> %s"
          % (s["id"], s["ea"], s["tf"], npar, vive, magic, magic + 1, os.path.basename(fn)))

print()
print("--- TABELLA PER IL DRIVER (nome, magic base, parametri attesi, righe vive attese) ---")
for s in SEDIE:
    ea, mv, tf, npar, vive, ma, mb = righe_finali[s["id"]]
    print('  @("%s","%s","%s","%s",%d,%d,%d,%d),' % (s["id"], ea, mv, tf, s["base"], npar, vive, s["grp"]))
