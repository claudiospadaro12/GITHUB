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
            for c in inpc:
                vs = sorted(vals[c])
                if len(vs) > 1:
                    ax[c.strip()][rel] = vs
                else:
                    cost[c.strip()][rel] = vs[0] if vs else ''
    return ax, cost, n

EAS = sorted([f[:-4] for f in os.listdir(os.path.join(ROOT, 'mql5', 'Experts'))
              if f.endswith('.mq5')], key=len, reverse=True)

def ea_of(rel):
    b = os.path.basename(rel)
    for e in EAS:
        if b.startswith(e) or ('/' + e + '/') in rel or ('/' + e.lower() + '/') in rel.lower():
            return e
    return None

def main():
    ax, cost, ncsv = indice_csv()
    # pre-aggregazione per EA
    per_ea_ax = collections.defaultdict(lambda: collections.Counter())
    per_ea_cost = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
    for c, m in ax.items():
        for rel in m:
            per_ea_ax[c][ea_of(rel)] += 1
    for c, m in cost.items():
        for rel, v in m.items():
            per_ea_cost[c][ea_of(rel)][v] += 1

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
                              celle=CELLE.get(c, CELLE_DEF)))
    out = os.path.join(ROOT, 'backtest_pipeline', 'risultati_archivio',
                       'CENSIMENTO_USCITE_2026-09-11.json')
    json.dump(dict(csv_con_inp=ncsv, righe=righe), open(out, 'w'), indent=1)

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
