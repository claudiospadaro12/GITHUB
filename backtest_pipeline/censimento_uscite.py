#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CENSIMENTO DELLE USCITE MAI PROVATE -- lo strumento che ha prodotto
report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md

DOMANDA: per ogni SEDIA VIVA, quali manopole dell'USCITA esistono nel suo EA
e quali NON sono mai state messe ad asse in nessuna corsa d'archivio?

TRE MISURE, e si dichiara sempre quale si sta usando:

 (1) AD ASSE DENTRO UN CSV
     La colonna prende >1 valore dentro lo stesso file di risultati.
     E' il caso classico: una griglia del tester con quell'asse acceso.

 (2) VARIATA FRA CORSE
     La colonna e' COSTANTE dentro ogni CSV ma prende valori diversi in file
     diversi. Succede quando un round usa un file prova per cella (R120, R125).
     >>> E' IL CONTRO-ESEMPIO PRINCIPALE: guardare solo (1) direbbe
         "mai provata" su qualcosa che E' stata provata.
     Misurato: InpBreakeven vale 1 in 985 file e 0 in 14.

 (3) MAI MOSSA
     Un solo valore in tutto l'archivio, ne' dentro ne' fra i file.

E UN CONTROLLO CHE LO SCRIPT NON PUO' FARE DA SOLO:
 (4) INERTE PER COSTRUZIONE
     La manopola esiste, non e' mai stata mossa, MA nella configurazione viva
     un altro input la disattiva -- quindi metterla ad asse costa passate e
     non misura niente. Esempio misurato: InpNewsFlatten sta dentro un ramo
     che si accende solo col blackout notizie, e InpUseNewsFilter=false in
     ogni preset vivo. Questo si verifica LEGGENDO IL CODICE, e la lista
     sta qui sotto in INERTI, con la riga di sorgente accanto.
     >>> Senza questo passo il referto avrebbe consegnato 27 caselle false.

Nessun numero stimato. Dove manca -> [NON MISURATO].
"""
import csv, os, re, json, collections

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ------------------------------------------------------------ le sedie vive
# Fonte: report/CENSIMENTO_CONTRATTI.md (07/09/2026), 41 sedie uniche.
# BREAKOUT_EA_JPY_v3 non ha sorgente nel repo: buco dichiarato.
SEDIE = [
 ("770101","ABTG_DAX_Apertura_EU","D30EUR","M5"),
 ("770202","ABTG_Dow_Apertura_US","U30USD","M5"),
 ("770250","ABTG_Nasdaq_Apertura_US","NASUSD","M15"),
 ("770402","ABTG_MaxMinNotte","XAUUSD","H2"),
 ("770411","ABTG_MaxMinNotte_DAX_Short_Ottimizzato","D30EUR","M15"),
 ("770511","ABTG_SuperWave_DOW_H1_Ottimizzato","U30USD","H1"),
 ("770531","ABTG_SuperWave","U30USD","H2"),
 ("770611","ABTG_ORB_Ottimizzato","U30USD","M5"),
 ("770901","ABTG_SupertrendReversal","225JPY","H2"),
 ("770924","ABTG_SupertrendReversal","225JPY","H2"),
 ("771201","ABTG_PostNews","EURJPY","M5"),
 ("771202","ABTG_PostNews","EURUSD","M5"),
 ("771203","ABTG_PostNews","USDJPY","M5"),
 ("771321","ABTG_PTE","U30USD","H1"),
 ("771322","ABTG_PTE","GBPUSD","H1"),
 ("771332","ABTG_PTE","GBPUSD","H1"),
 ("771531","ABTG_EMA200","U30USD","H1"),
 ("772161","ABTG_BreakingBand","GBPUSD","H1"),
 ("772162","ABTG_BreakingBand","EURUSD","H1"),
 ("772163","ABTG_BreakingBand","AUDUSD","H1"),
 ("772231","ABTG_GapFill","GBPUSD","-"),
 ("772232","ABTG_GapFill","EURUSD","-"),
 ("772233","ABTG_GapFill","AUDUSD","-"),
 ("772234","ABTG_GapFill","U30USD","-"),
 ("772235","ABTG_GapFill","225JPY","-"),
 ("772341","ABTG_PunteLarry","U30USD","H1"),
 ("772342","ABTG_PunteLarry","EURAUD","H1"),
 ("772343","ABTG_PunteLarry","XAUUSD","H1"),
 ("772344","ABTG_PunteLarry","GBPJPY","H1"),
 ("772345","ABTG_PunteLarry","GBPUSD","H1"),
 ("772346","ABTG_PunteLarry","EURCAD","H1"),
 ("772361","ABTG_CostToCost","EURJPY","-"),
 ("772362","ABTG_CostToCost","GBPCAD","-"),
 ("772421","ABTG_EasyTrend","CHFJPY","-"),
 ("772422","ABTG_EasyTrend","GBPUSD","-"),
 ("774101","ABTG_GapContinuation","225JPY","M1"),
 ("970901","ABTG_SupertrendReversal_Ottimizzato","XAUUSD","H4"),
 ("970912","ABTG_SupRev_DAX_H4_Ottimizzato","D30EUR","H4"),
 ("970913","ABTG_SupRev_NAS_H1_Ottimizzato","NASUSD","H1"),
 ("971501","ABTG_EMA200_Ottimizzato","XAUUSD","H4"),
]

# ------------------------------------------- cosa conta come "uscita", e cosa no
CAT = [
 ("stop:modo",    r'(SLMode|StopMode|SL_Mode|ModoStop|InpSLType)'),
 ("stop:misura",  r'(AtrSLmult|AtrSlMult|SLatr$|SL_ATRmult|SLFixedPts|StopLossPts|SLPoints|'
                  r'SLAtr|StopAtr|SLLookback|StopLookback|SLPips$|SLpips$|InpStopLoss|SLGapMult|'
                  r'MinStopPts|SkipIfTight|MaxSpreadToStopPercent)'),
 ("stop:buffer",  r'(SLBuffer|StopBuffer|BufferStop|SL_Buffer)'),
 ("trailing",     r'(Trail|Chandelier)'),
 ("breakeven",    r'(Breakeven|BreakEven|InpBE|BEat|BeAt|BE_|Be[A-Z])'),
 ("parziale",     r'(TP1Pct|TP2Pct|TP1_|Partial|Parziale|FirstFraction|TP2_|TP3_|Scale|Runner)'),
 ("target",       r'(TP_R|TPMode|TPRangeMult|TP_RR|TpR$|InpRR|FinalTargetR|TakeProfit|TP_ATR|'
                  r'TPatr|TPPts|TP_Pts|TargetR|TPMult|TPfinal|TPpips|UseEMA200Target|'
                  r'TPRefreshBars|MinTPatATR|UseOCO)'),
 ("uscita:orario",r'(CloseAtEnd|CloseHour|EndHour|EndMin|ExitHour|ExitMin|FlatOra|FridayClose|'
                  r'MaxBars|BarreMax|OreDurata|MaxMinuti|MaxMinutes|TimeStop|MaxHold|DurataMax|'
                  r'MaxHours|MaxDaysHold|ExitMinutesBeforeClose|SessionCloseHour|CloseAtExpiry|'
                  r'ExpiryHour|ExpiryMin|BoxEnd)'),
 ("uscita:segnale",r'(ExitOn|CloseOn|HalveOn|ExitPeriod|ExitMiddle|ExitMode|ExitSignal|AtrExitPeriod)'),
 ("uscita:news",  r'(NewsFlatten|FlattenOnNews)'),
]
# nomi che il classificatore per NOME prenderebbe ma che NON sono uscite
NONUSCITA = re.compile(
  r'(EntryPoints|RangeEndHour|RangeEndMin|RangeStart|PendingExpiry|EmaFast|EmaSlow|Ema200Period|'
  r'AtrPeriod$|InpMagic|InpComment|Verbose|Slippage|InpMaxSpread$|InpMaxSpreadPts$|BulgeMaxBars|'
  r'BandRidingMaxBars|PostBulgeMaxBars|DivMaxBars|WarmupBars|EntryWindowBars|MaxPivotDist|'
  r'TrendSlopeBars|BulgeRefBars)')
# falsi positivi residui, esclusi a mano dopo aver letto il codice
FUORI = {('ABTG_MaxMinNotte','InpBoxEndHour'),('ABTG_MaxMinNotte','InpBoxEndMin'),
 ('ABTG_MaxMinNotte_DAX_Short_Ottimizzato','InpBoxEndHour'),
 ('ABTG_MaxMinNotte_DAX_Short_Ottimizzato','InpBoxEndMin'),   # il BOX e' l'ingresso, non l'uscita
 ('ABTG_PostNews','InpExpiryHour'),('ABTG_PostNews','InpExpiryMin'),  # scadenza PENDENTI
 ('ABTG_GapContinuation','InpMaxSpreadToStopPercent'),        # filtro di costo, non uscita
 ('ABTG_PostNews','InpRiskRefSLpips')}                        # sizing, non uscita

# --------------------------- (4) INERTI PER COSTRUZIONE nella configurazione VIVA
#     Ognuna LETTA NEL CODICE + nel preset vivo. Non dedotte.
_APE = ('770101','770202','770250')
INERTI = {}
for _m in ('770101','770202','770250','770402','770411','770611'):
    INERTI[(_m,'InpNewsFlatten')] = ("InNewsBlackout() torna false con InpUseNewsFilter=false "
        "(ORB r.1353 / Apertura r.558 / MaxMin r.812); false in ogni preset vivo")
for _m in _APE:
    INERTI[(_m,'InpTrailAtrMult')]  = "ramo TRAIL_ATR morto: InpTrailMode=1 (PREVBAR) nel preset vivo"
    INERTI[(_m,'InpTrailFixedPts')] = "ramo TRAIL_FIXED morto: InpTrailMode=1 (PREVBAR) nel preset vivo"
    INERTI[(_m,'InpAtrSlMult')]     = "ramo SL_ATR morto: InpSLMode=0 (SL_RANGE) nel preset vivo"
for _m in ('772231','772232','772233','772234','772235','772341','772342','772343','772344','772345','772346'):
    INERTI[(_m,'InpAtrSlMult')] = "serve solo con InpSLMode=1, che vale 0 in ogni corsa d'archivio"
INERTI[('770611','InpAtrSLmult')]  = "ramo ORB_SL_ATR morto: InpSLMode=3 (HALFRANGE) nel preset reale"
INERTI[('770611','InpSLFixedPts')] = "ramo ORB_SL_FIXED morto: InpSLMode=3 (HALFRANGE) nel preset reale"
INERTI[('770611','InpBreakeven')]  = "ABTG_ORB_Ottimizzato.mq5 r.662 lo stampa: InpTP1Pct=0 -> nessuno stop in pari"
INERTI[('770411','InpSLFixedPts')] = "ramo FIXED morto: InpSLMode=1 (ATR) in ABTG_MaxMinNotte_DAX.set"

# celle proposte per un asse leggibile (>=3 celle: passo P4 di R125)
CELLE = {'InpTrailOnST':2,'InpExitOnFlip':2,'InpFirstFraction':3,'InpSLBufferPips':9,
 'InpSLLookback':7,'InpSLBufferAtr':9,'InpCloseAtEnd':2,'InpNewsFlatten':2,'InpMaxBarsHold':8,
 'InpMaxHours':7,'InpMaxDaysHold':7,'InpSLGapMult':6,'InpBEMode':2,'InpBEatATR':6,
 'InpMinTPatATR':5,'InpSL_ATRmult':7,'InpTPRefreshBars':4,'InpPartialTargetR':5,
 'InpPartialClosePercent':5,'InpMoveStopToBreakEven':2,'InpSessionCloseHour':5,
 'InpExitMinutesBeforeClose':4,'InpStopBufferPoints':7,'InpRunnerTP_R':5,'InpAtrExitPeriod':5,
 'InpUseTrail25':2,'InpTrailTriggerPips':6,'InpTrailNewSLpips':6,'InpCloseAtExpiry':2,
 'InpUseOCO':2,'InpTPpips':6,'InpFridayCloseMin':4}
CELLE_DEF = 5

# ------------------------------------------------------------------- utilita'
INP = re.compile(r'^\s*(?:s?input)\s+(\w+)\s+(\w+)\s*=\s*([^;]+);(?:\s*//\s*(.*))?')

def inputs_ea(path):
    out = []
    for i, l in enumerate(open(path, encoding='utf-8', errors='replace'), 1):
        m = INP.match(l)
        if m:
            out.append(dict(riga=i, nome=m.group(2), default=m.group(3).strip()))
    return out

def categoria(nome):
    if NONUSCITA.search(nome):
        return None
    for c, rx in CAT:
        if re.search(rx, nome):
            return c
    return None

def leggi(path):
    for enc in ('utf-8-sig', 'utf-16', 'latin-1'):
        try:
            raw = open(path, 'r', encoding=enc, newline='').read()
            if '\x00' in raw:
                continue
            return raw
        except Exception:
            continue
    return None

def indice_csv():
    """col -> {'ax': {file: [valori]}, 'cost': {file: valore}}"""
    ax = collections.defaultdict(dict)
    cost = collections.defaultdict(dict)
    n = 0
    for dp, dn, fn in os.walk(ROOT):
        if '/.git' in dp:
            continue
        for f in sorted(fn):
            if not f.lower().endswith('.csv'):
                continue
            p = os.path.join(dp, f)
            raw = leggi(p)
            if not raw:
                continue
            lines = raw.splitlines()
            if not lines or 'Inp' not in lines[0]:
                continue
            delim = ';' if lines[0].count(';') > lines[0].count(',') else ','
            try:
                rdr = csv.DictReader(lines, delimiter=delim)
                cols = rdr.fieldnames or []
            except Exception:
                continue
            inpc = [c for c in cols if c and c.strip().startswith('Inp')]
            if not inpc:
                continue
            n += 1
            vals = collections.defaultdict(set)
            for r in rdr:
                for c in inpc:
                    vals[c].add((r.get(c) or '').strip())
            rel = os.path.relpath(p, ROOT)
            # scheda del file: serve all'attribuzione (ea_of) -- vie MAGIC e FIRMA
            META[rel] = dict(cols=[c.strip() for c in inpc],
                             magics=sorted(v for v in vals.get('InpMagic', ()) if v))
            for c in inpc:
                vs = sorted(vals[c])
                if len(vs) > 1:
                    ax[c.strip()][rel] = vs
                else:
                    cost[c.strip()][rel] = vs[0] if vs else ''
    return ax, cost, n

EAS = sorted([f[:-4] for f in os.listdir(os.path.join(ROOT, 'mql5', 'Experts'))
              if f.endswith('.mq5')], key=len, reverse=True)

# ============================================================================
# CHI HA PRODOTTO QUESTO CSV -- attribuzione (riparata l'11/09/2026)
# ----------------------------------------------------------------------------
# IL DIFETTO RIPARATO: la versione precedente riconosceva un CSV solo se il
# BASENAME COMINCIAVA col nome dell'EA (o se stava in una cartella omonima).
# Misurato: 668 file che SONO risultati di round (colonne InpMagic E Profit)
# tornavano None -- fra cui TUTTE le corse EMA200 (scan_*/valid_*), tutti i
# gestione_* e i DAX_F_gestione_*. Il censimento leggeva 1.419 CSV su 2.087:
# i suoi totali erano LIMITI SUPERIORI, non misure.
#
# LA DIREZIONE OPPOSTA, che e' il pericolo vero: allargare il riconoscimento
# crea FALSI POSITIVI, e un falso positivo e' PEGGIO di un falso negativo --
# fa dichiarare "provata" una manopola che non lo e'. Percio' ogni via passa
# lo stesso VETO, e le vie sono ordinate per forza della prova.
#
#   VETO (uguale per tutte e tre): ogni colonna Inp* del CSV dev'essere un
#   input DICHIARATO in quell'EA (firma delle colonne). Un CSV lo scrive il
#   tester copiando i nomi degli input: se una colonna non esiste in quell'EA,
#   quel CSV non l'ha prodotto quell'EA. Misurato: su tutti i file che la
#   versione vecchia attribuiva, la copertura e' 1,000 -- il veto non toglie
#   nulla di gia' buono (0 regressioni), e taglia i falsi positivi.
#
#   VIA 1 -- PATH: il nome dell'EA compare OVUNQUE nel percorso (non solo in
#     testa). I nomi che si contengono a vicenda (ABTG_PTE dentro
#     ABTG_PTE_Ottimizzato) si risolvono tenendo solo i MASSIMALI: se il
#     percorso contiene il nome lungo, il corto non e' una prova a se'.
#     Se restano DUE nomi massimali diversi -> AMBIGUO -> None.
#   VIA 2 -- MAGIC: la colonna InpMagic incrociata con la mappa magic->EA che
#     il repo GIA' possiede: il default dichiarato nel sorgente dell'EA
#     (input InpMagic / #define ABTG_DEF_MAGIC) piu' la tabella SEDIE qui
#     sopra (fonte: report/CENSIMENTO_CONTRATTI.md). Nessun numero inventato.
#     I magic usati da PIU' EA (770301 GoldenCross/V1, 771401 AltaVelocita/WOL,
#     250604 i tre EA oro, 20260304) sono SCARTATI, non indovinati.
#     Il magic e' la via DEBOLE: i round lo ri-etichettano per distinguere le
#     celle (R83: InpMagic 777120/777121 dentro un CSV di Apertura_3Ingressi),
#     quindi vale solo quando il percorso tace. MISURATO che sbaglia: due file
#     r50/r59 portano InpMagic=772700 (ABTG_Bulge) ma le loro colonne sono di
#     ABTG_EasyTrend e ABTG_PunteLarry -- il veto li ferma entrambi.
#   VIA 3 -- FIRMA: se percorso e magic tacciono, e UN SOLO EA di tutto il
#     parco ha un insieme di input che CONTIENE tutte le colonne Inp* del CSV,
#     e' quello. Se ne bastano due -> AMBIGUO -> None (i 40 PTEGBP_* di R80
#     restano None cosi': ABTG_PTE e ABTG_PTE_Ottimizzato li contengono
#     entrambi, e tirare a indovinare sarebbe esattamente il falso positivo).
# ============================================================================

_RX_DEF_MAGIC = re.compile(r'^\s*#define\s+ABTG_DEF_MAGIC\s+(\d+)')
_RX_INP_MAGIC = re.compile(r'^\s*(?:s?input)\s+\w+\s+InpMagic(?:Number)?\s*=\s*(\w+)')

def _sorgente(ea):
    return os.path.join(ROOT, 'mql5', 'Experts', ea + '.mq5')

def _magic_dichiarato(ea):
    """Il magic DI DEFAULT scritto nel sorgente dell'EA. None se non c'e'."""
    dfn = None
    mag = None
    for l in open(_sorgente(ea), encoding='utf-8', errors='replace'):
        if dfn is None:
            m = _RX_DEF_MAGIC.match(l)
            if m:
                dfn = m.group(1)
        if mag is None:
            m = _RX_INP_MAGIC.match(l)
            if m:
                mag = m.group(1)
    if mag == 'ABTG_DEF_MAGIC':
        mag = dfn
    return mag if (mag and mag.isdigit()) else None

def _mappa_magic():
    per_magic = collections.defaultdict(set)
    for e in EAS:
        m = _magic_dichiarato(e)
        if m:
            per_magic[m].add(e)
    for magic, ea, _s, _t in SEDIE:      # report/CENSIMENTO_CONTRATTI.md
        per_magic[magic].add(ea)
    uni = {m: next(iter(v)) for m, v in per_magic.items() if len(v) == 1}
    amb = {m: sorted(v) for m, v in per_magic.items() if len(v) > 1}
    return uni, amb

MAGIC2EA, MAGIC_AMBIGUI = _mappa_magic()
EA_INPUTS = {e: {u['nome'] for u in inputs_ea(_sorgente(e))} for e in EAS}

# rel -> {'cols': [colonne Inp*], 'magics': [valori distinti di InpMagic]}
# lo riempie indice_csv(); l'autotest lo riempie a mano coi file veri.
META = {}

def _firma_ok(ea, cols):
    """VETO: ogni colonna Inp* del CSV dev'essere un input di quell'EA."""
    cols = set(cols or ())
    return bool(cols) and cols <= EA_INPUTS.get(ea, set())

def ea_of(rel, cols=None, magics=None, con_via=False):
    """L'EA che ha prodotto il CSV `rel`, o None se non e' dimostrabile."""
    if cols is None:
        cols = META.get(rel, {}).get('cols', [])
    if magics is None:
        magics = META.get(rel, {}).get('magics', [])
    low = rel.lower()

    # VIA 1 -- il nome nel percorso, solo i massimali
    hit = [e for e in EAS if e.lower() in low]
    hit = [e for e in hit if not any(o != e and e.lower() in o.lower() for o in hit)]
    ok = [e for e in hit if _firma_ok(e, cols)]
    if len(ok) == 1:
        return (ok[0], 'PATH') if con_via else ok[0]
    if len(ok) > 1:
        return (None, 'PATH-AMBIGUO') if con_via else None

    # VIA 2 -- il magic, incrociato con la mappa del repo
    mg = sorted({MAGIC2EA[m] for m in magics if m in MAGIC2EA})
    mg = [e for e in mg if _firma_ok(e, cols)]
    if len(mg) == 1:
        return (mg[0], 'MAGIC') if con_via else mg[0]
    if len(mg) > 1:
        return (None, 'MAGIC-AMBIGUO') if con_via else None

    # VIA 3 -- la firma delle colonne, e dev'essere UNICA
    fw = [e for e in EAS if _firma_ok(e, cols)]
    if len(fw) == 1:
        return (fw[0], 'FIRMA') if con_via else fw[0]
    return (None, 'FIRMA-AMBIGUA' if fw else 'NESSUNA') if con_via else None

def ea_of_vecchia(rel, cols=None, magics=None, con_via=False):
    """La versione ROTTA, tenuta SOLO per misurare il delta (--delta)."""
    b = os.path.basename(rel)
    for e in EAS:
        if b.startswith(e) or ('/' + e + '/') in rel or ('/' + e.lower() + '/') in rel.lower():
            return (e, 'VECCHIA') if con_via else e
    return (None, 'VECCHIA') if con_via else None

def censimento(ax, cost, attr=None):
    """Le righe sedia x manopola, con l'attribuzione `attr` (default: ea_of)."""
    attr = attr or ea_of
    per_ea_ax = collections.defaultdict(lambda: collections.Counter())
    per_ea_cost = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
    # quale CSV dimostra cosa: (ea, knob) -> {rel: [valori distinti]}
    prova = collections.defaultdict(dict)
    for c, m in ax.items():
        for rel, vs in m.items():
            e = attr(rel)
            per_ea_ax[c][e] += 1
            if e:
                prova[(e, c)][rel] = vs
    for c, m in cost.items():
        for rel, v in m.items():
            per_ea_cost[c][attr(rel)][v] += 1

    righe = []
    for magic, ea, sym, tf in SEDIE:
        src = os.path.join(ROOT, 'mql5', 'Experts', ea + '.mq5')
        if not os.path.exists(src):
            righe.append(dict(magic=magic, ea=ea, sym=sym, tf=tf, errore='SORGENTE ASSENTE'))
            continue
        for u in inputs_ea(src):
            cat = categoria(u['nome'])
            if not cat or (ea, u['nome']) in FUORI:
                continue
            c = u['nome']
            pe = dict(per_ea_cost.get(c, {}).get(ea, {}))
            axea = per_ea_ax.get(c, {}).get(ea, 0)
            axtot = len(ax.get(c, {}))
            cvtot = len({v for v in cost.get(c, {}).values()})
            if axea > 0:
                st = 'ASSE'
            elif len(pe) > 1:
                st = 'CORSE'
            elif len(pe) == 0:
                st = 'MAI-assente'
            elif axtot > 0:
                st = 'MAI-gemello'
            elif cvtot > 1:
                st = 'MAI-altroEA'
            else:
                st = 'MAI-ovunque'
            righe.append(dict(magic=magic, ea=ea, sym=sym, tf=tf, knob=c, cat=cat,
                              default=u['default'], riga=u['riga'], stato=st,
                              mai=st.startswith('MAI'),
                              inerte=(magic, c) in INERTI,
                              motivo=INERTI.get((magic, c), ''),
                              celle=CELLE.get(c, CELLE_DEF),
                              prove=sorted(prova.get((ea, c), {}).items())[:4]))
    return righe

def main():
    ax, cost, ncsv = indice_csv()
    righe = censimento(ax, cost)
    out = os.path.join(ROOT, 'backtest_pipeline', 'risultati_archivio',
                       'CENSIMENTO_USCITE_2026-09-11.json')
    json.dump(dict(csv_con_inp=ncsv, righe=righe), open(out, 'w'), indent=1)
    attrib = sum(1 for r in META if ea_of(r))
    print("csv attribuiti a un EA:", attrib, "/", len(META),
          "| non attribuibili (dichiarati, non indovinati):", len(META) - attrib)

    mai = [r for r in righe if r.get('mai')]
    ine = [r for r in mai if r['inerte']]
    print("csv con colonne Inp*:", ncsv, "| colonne Inp* distinte:", len(set(ax) | set(cost)))
    print("sedie:", len(SEDIE), "| coppie sedia x manopola d'uscita:",
          len([r for r in righe if 'knob' in r]))
    print("MAI MOSSE su quella sedia:", len(mai),
          "| di cui INERTI PER COSTRUZIONE:", len(ine),
          "| MAI MOSSE E VIVE:", len(mai) - len(ine))
    print("mai mosse in TUTTO l'archivio (coppie EA x manopola):",
          len({(r['ea'], r['knob']) for r in righe if r.get('stato') == 'MAI-ovunque'}))
    print("passate per metterle tutte ad asse:",
          sum(r['celle'] * 2 for r in mai if not r['inerte']))
    print("scritto:", os.path.relpath(out, ROOT))

if __name__ == '__main__':
    main()
