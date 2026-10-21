#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r274_giudizio.py -- 21/10/2026

IL LETTORE DEI PER-TRADE DI R274 "OROLOGIO DELLA SEDIA 770260" (Nasdaq,
ABTG_Nasdaq_Apertura_US NASUSD M5). Scritto e congelato PRIMA di aprire lo ZIP
ROUND_R274_<data>.zip, come prescrive prove/R274a par. 4 ("lo script di lettura
per questa famiglia va scritto PRIMA di aprire i per-trade, con questi criteri
come specifica, e con un --autotest"). Nessun numero reale e' stato visto.

SPECIFICA (tutto da prove/R274a_orologio_d0_B_NASDAQ_NASUSD.txt par. 1-6 e dalle
differenze di R274b, R274c, R274d; il modello e' r246_giudizio_d1.py):
  file   orologio            finestra  magic gemelli  InpSessionHour
  R274a  d0  14:30 / 17:30   B         798201/798251  14
  R274b  d+1 15:30 / 18:30   B         798211/798261  15
  R274c  d0  14:30 / 17:30   A         798202/798252  14
  R274d  d+1 15:30 / 18:30   A         798212/798262  15
  B = 2024.09.26-2026.06.30 (IS fino al taglio 0.40; il per-trade e' l'OOS
  2025.06.10-2026.06.30, 276 feriali); A = 2024.09.26-2025.06.09 (taglio 0.002:
  la gamba IS dura un giorno, CSV _IS vuoto ATTESO; il per-trade e' il primo
  inverno 2024.09.27-2025.06.09, 182 feriali). A+B per-trade = 458 feriali:
  USA 278 estate / 180 inverno; UE 238 estate / 220 inverno.

ORDINE OBBLIGATORIO (classe 750: i cancelli PRIMA dei numeri):
  G1 determinismo (ogni file) -> G0 riproduzione (solo R274a) -> G2 coerenza
  fra finestre -> S1 sentinella dell'orologio (+ colonna InpSessionHour)
  -> SOLO DOPO: tassi, Df, Qf2, bande, serie "COME FTMO" (R2 frequenza,
  R1 rischio), conteggio per lato (DESCRITTIVO).
  Se G0 e' ROSSO: round NON CONFRONTABILE, ci si ferma e non si stampa nessun
  verdetto (R274a par. 3).

TOLLERANZA DI BANCO (par. 3): identico = Trades ed Equity DD % ESATTI; Profit
|diff| <= 1,00 EUR; PF e RF |diff| <= 0,0002. G1 invece e' alla LETTERA
(un centesimo e' una differenza), come in r246_giudizio.py.

VERDETTO (par. 4, congelato): tassi in POSIZIONI per feriale (posizioni =
(etichetta cella, position_id) distinti, per stagione USA della DATA DI
CHIUSURA; il PF si scrive e NON decide: n < 150 per costruzione).
  Df  = r_w0 - r_s0   deve essere >= 0,15 pos/feriale, altrimenti
        "DIVARIO NON RIPRODOTTO"
  Qf2 = (r_w0 - r_w1) / (r_w0 - r_s0)   >= 0,70 OROLOGIO, <= 0,30 STAGIONE,
        in mezzo MISTO
  bande 1 sigma congelate: H_ORA 12-65 posizioni, H_STAGIONE 83-166 (d+1
  d'inverno A+B), ricalcolate anche dai tassi VERI di d0.
  Serie COME FTMO (calendario UE): d0 nei giorni UE d'estate + d+1 nei giorni
  UE d'inverno (458 feriali). R2: r_FTMO < 0,25 pos/feriale = sotto il promesso
  0,37 -> revisione di Claudio. R1 (qualunque n): DD di saldo (cumulata dei
  net_profit per data di chiusura, deposito 80000, lotti NON ricalcolati
  [DERIVATO]) > 10% -> revisione IMMEDIATA; 7,86% < DD <= 10% = SOPRA IL
  CONTRATTO; contratto 7,31% IS / 7,86% OOS.

SCHEMA per-trade (letto da ABTG_Nasdaq_Apertura_US.mq5 r.2567-2577: solo le
USCITE, DEAL_ENTRY_OUT / OUT_BY): colonne, separatore ';':
  close_time;symbol;magic;position_id;deal_type;volume;price;net_profit
deal_type = DEAL_TYPE del deal di USCITA: 1 = SELL (chiude un LONG),
0 = BUY (chiude uno SHORT). Uno stesso position_id puo' avere piu' uscite
(chiusure parziali, InpTP1_ClosePct): le posizioni si contano per position_id.
SCHEMA CSV round (IS/OOS): riga per magic (colonna InpMagic), colonne Profit,
Profit Factor, Recovery Factor, Equity DD %, Trades, InpSessionHour, ...

LAYOUT ATTESO della cartella (quello di RIGA_R274_OROLOGIO_NASDAQ.txt):
  <cartella>/ROUND_R274a/ .. ROUND_R274d/  con
        ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R274x.csv
  <cartella>/PERTRADE/abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_<magic>.csv
  (il lettore cerca per nome anche dentro sottocartelle).

USO:  python3 backtest_pipeline/r274_giudizio.py <cartella ROUND_R274_data>
      python3 backtest_pipeline/r274_giudizio.py --autotest
"""
import collections
import csv
import datetime as dt
import decimal
import os
import sys
import tempfile

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r246_giudizio as g  # noqa: E402  (cent, leggi_pt, dd_saldo, zona, aggrega, giorno, ora)
import r246_bande_attese as rb  # noqa: E402  (calendario inverno/feriali, pf)

EA = 'ABTG_Nasdaq_Apertura_US'
SIM = 'NASUSD'
DEP = 80000.0
# lettera -> (orologio, finestra, magic m); gemella = m + 50
FILES = {
    'a': ('d0', 'B', 798201), 'b': ('d1', 'B', 798211),
    'c': ('d0', 'A', 798202), 'd': ('d1', 'A', 798212),
}
ORA_CSV = {'d0': 14, 'd1': 15}      # InpSessionHour atteso (ora SERVER BCM)
CLOSE_CSV = {'d0': 17, 'd1': 18}    # InpCloseHour atteso (rilievo, non cancello)
# finestre del PER-TRADE (OOS): A parte il 27/09, B arriva al 30/06/2026 (276 feriali)
FIN = {'A': (dt.date(2024, 9, 27), dt.date(2025, 6, 9)),
       'B': (dt.date(2025, 6, 10), dt.date(2026, 6, 30))}
# S1 (par. 3-4): (uscita minima, uscita massima); dopo il massimo e prima delle 23:00 = ROSSO
S1 = {'d0': ('15:05:00', '17:31:00'), 'd1': ('16:05:00', '18:31:00')}
RIAPERTURA = '23:00:00'
G2_COPPIE = [('c', 'a'), ('d', 'b')]
CAMPI_CSV = ('Profit', 'Profit Factor', 'Equity DD %', 'Trades')
# G0: R199B Pass=2 (par. 2): (Profit, PF, RF, Equity DD %, Trades)
G0_RIF = {'IS': ('7014.20', '1.22116', '1.14977', '7.3069', '135'),
          'OOS': ('8496.74', '1.21546', '1.29687', '7.8576', '172')}
G0_PT_OOS = dict(righe=172, pos=102)
G0_TOL = dict(profit=decimal.Decimal('1.00'), pf=decimal.Decimal('0.0002'), rf=decimal.Decimal('0.0002'))
SOGLIA_DF = 0.15
BANDE_POS = ((83, 166), (12, 65))   # (H_STAGIONE, H_OROLOGIO) come g.dove_cade
R2_SOGLIA, R2_PROMESSO = 0.25, 0.37
DD_CONTRATTO, DD_MURO = 7.86, 10.0
N_FERIALI_ATTESI = dict(USA=(278, 180), UE=(238, 220))


# ---------------------------------------------------------------- calendario
def feriali_AB(cal):
    """feriali delle finestre per-trade A (182) + B (276), per stagione di calendario"""
    fa, fb = rb.feriali(FIN['A'][0], FIN['A'][1], cal), rb.feriali(FIN['B'][0], FIN['B'][1], cal)
    return dict(E=fa[0] + fb[0], I=fa[1] + fb[1], AE=fa[0], AI=fa[1], BE=fb[0], BI=fb[1])


def zona(q):
    return g.zona(q)


# ---------------------------------------------------------------- lettura
def _D(s):
    return decimal.Decimal(str(s).strip().replace(',', '.'))


def leggi_csv_round(path):
    """('MANCA'|'VUOTO'|'OK', {magic: riga})"""
    if path is None or not os.path.exists(path):
        return 'MANCA', {}
    if os.path.getsize(path) == 0:
        return 'VUOTO', {}
    with open(path, newline='', encoding='utf-8-sig', errors='replace') as fh:
        rows = list(csv.DictReader(fh))
    out = {}
    for r in rows:
        try:
            out[int(float(r['InpMagic']))] = r
        except (KeyError, ValueError):
            continue
    return ('OK', out) if out else ('VUOTO', {})


def trova(root, nome):
    """percorso del primo file chiamato nome sotto root (preferisce PERTRADE/)"""
    hit = []
    for d, _, fs in os.walk(root):
        if nome in fs:
            hit.append(os.path.join(d, nome))
    hit.sort(key=lambda p: (os.path.basename(os.path.dirname(p)) != 'PERTRADE', p))
    return hit[0] if hit else None


def carica(root):
    dati = dict(csv={}, pt={}, root=root)
    for lett in FILES:
        for gamba in ('IS', 'OOS'):
            nome = f"{EA}_{SIM}_{gamba}_R274{lett}.csv"
            dati['csv'][(lett, gamba)] = leggi_csv_round(trova(root, nome))
        m = FILES[lett][2]
        for tw in (m, m + 50):
            p = trova(root, f"abtg_trades_{EA}_{SIM}_{tw}.csv")
            dati['pt'][(lett, tw)] = g.leggi_pt(p) if p else None
    return dati


# ---------------------------------------------------------------- G1 + colonna ora
def senza_magic(rows):
    return [{k: v for k, v in r.items() if k != 'magic'} for r in rows]


def g1(dati, lett):
    """(esito, differenze). Alla lettera, nessuna tolleranza. CSV _IS vuoto sulle A = ATTESO."""
    orol, fin, m = FILES[lett]
    tw = m + 50
    diff = []
    for gamba in ('IS', 'OOS'):
        stato, rows = dati['csv'][(lett, gamba)]
        if stato != 'OK':
            if gamba == 'IS' and fin == 'A':
                continue
            diff.append(f"CSV {gamba} {stato}")
            continue
        if m not in rows or tw not in rows:
            diff.append(f"CSV {gamba} senza le due gemelle ({m}, {tw})")
            continue
        for f in CAMPI_CSV:
            if rows[m].get(f) != rows[tw].get(f):
                diff.append(f"CSV {gamba} {f}: {rows[m].get(f)} vs {rows[tw].get(f)}")
        if gamba == 'OOS':
            for mg in (m, tw):
                t = str(rows[mg].get('Trades', '')).strip()
                if not (t.isdigit() and int(t) > 0):
                    diff.append(f"CSV OOS magic {mg}: Trades '{t}' non > 0")
    pm, pg = dati['pt'].get((lett, m)), dati['pt'].get((lett, tw))
    if pm is None or pg is None:
        diff.append('per-trade mancante (' + ', '.join(str(x) for x, p in ((m, pm), (tw, pg)) if p is None) + ')')
    elif len(pm) != len(pg):
        diff.append(f"per-trade righe {len(pm)} vs {len(pg)}")
    else:
        for i, (x, y) in enumerate(zip(senza_magic(pm), senza_magic(pg)), 2):
            if x != y:
                diff.append(f"per-trade riga {i}: " + ', '.join(f"{k} {x[k]} vs {y.get(k)}" for k in x if x[k] != y.get(k)))
                break
    return ('PASS' if not diff else 'NULLO'), diff


def gate_ora(dati, lett):
    """InpSessionHour dei CSV deve essere 14 (d0) / 15 (d1): se no il CSV si CESTINA = file NULLO.
    Rilievi (non annullano): InpSessionMin != 30, InpCloseHour != 17/18."""
    orol, fin, m = FILES[lett]
    ko, ril, visti = [], [], 0
    for gamba in ('IS', 'OOS'):
        stato, rows = dati['csv'][(lett, gamba)]
        if stato != 'OK':
            continue
        for mg in (m, m + 50):
            if mg not in rows:
                continue
            visti += 1
            h = str(rows[mg].get('InpSessionHour', '')).strip()
            if h != str(ORA_CSV[orol]):
                ko.append(f"{gamba} magic {mg}: InpSessionHour '{h}' invece di {ORA_CSV[orol]}")
            mn = str(rows[mg].get('InpSessionMin', '30')).strip()
            ch = str(rows[mg].get('InpCloseHour', str(CLOSE_CSV[orol]))).strip()
            if mn != '30':
                ril.append(f"{gamba} magic {mg}: InpSessionMin '{mn}' (atteso 30)")
            if ch != str(CLOSE_CSV[orol]):
                ril.append(f"{gamba} magic {mg}: InpCloseHour '{ch}' (atteso {CLOSE_CSV[orol]})")
    if visti == 0:
        ko.append('nessuna riga CSV leggibile: ora NON verificata')
    return ('OK' if not ko else 'NULLO'), ko, ril


# ---------------------------------------------------------------- G0
def g0(dati):
    """solo R274a (d0, finestra B = cella d'archivio R199B Pass=2). Ritorna (esito, righe)."""
    m = FILES['a'][2]
    righe, ok = [], True
    for gamba in ('IS', 'OOS'):
        stato, rows = dati['csv'][('a', gamba)]
        rif = G0_RIF[gamba]
        for mg in (m, m + 50):
            if stato != 'OK' or mg not in rows:
                righe.append(f"{gamba} magic {mg}: CSV {stato if stato != 'OK' else 'senza la riga'} -> ROSSO")
                ok = False
                continue
            r = rows[mg]
            try:
                profit, pf, rf = _D(r['Profit']), _D(r['Profit Factor']), _D(r['Recovery Factor'])
                dd, tr = _D(r['Equity DD %']), int(float(r['Trades']))
            except (KeyError, ValueError, decimal.InvalidOperation):
                righe.append(f"{gamba} magic {mg}: campi illeggibili -> ROSSO")
                ok = False
                continue
            e = [('Trades', tr == int(rif[4]), tr, rif[4]),
                 ('Equity DD %', dd == _D(rif[3]), dd, rif[3]),
                 ('Profit', abs(profit - _D(rif[0])) <= G0_TOL['profit'], profit, rif[0]),
                 ('PF', abs(pf - _D(rif[1])) <= G0_TOL['pf'], pf, rif[1]),
                 ('RF', abs(rf - _D(rif[2])) <= G0_TOL['rf'], rf, rif[2])]
            bad = [f"{n} {a} vs {b}" for n, o, a, b in e if not o]
            righe.append(f"{gamba} magic {mg}: " + ('IN TOLLERANZA DI BANCO' if not bad else 'FUORI: ' + '; '.join(bad)))
            ok &= not bad
    for mg in (m, m + 50):
        pt = dati['pt'].get(('a', mg))
        if pt is None:
            righe.append(f"per-trade OOS magic {mg}: mancante -> ROSSO")
            ok = False
            continue
        n, npos = len(pt), len({r['position_id'] for r in pt})
        good = (n, npos) == (G0_PT_OOS['righe'], G0_PT_OOS['pos'])
        righe.append(f"per-trade OOS magic {mg}: {n} deal / {npos} posizioni (R199B: {G0_PT_OOS['righe']} / {G0_PT_OOS['pos']}) "
                     + ('OK' if good else 'FUORI -> ROSSO'))
        ok &= good
    return ('VERDE' if ok else 'ROSSO'), righe


# ---------------------------------------------------------------- G2
def g2(dati):
    """lista di (etichetta, ok, testo). Coerenza fra finestre e per-trade contro gamba OOS del proprio CSV."""
    out = []
    for lett in FILES:
        orol, fin, m = FILES[lett]
        for off in (0, 50):
            pt = dati['pt'].get((lett, m + off))
            stato, rows = dati['csv'][(lett, 'OOS')]
            if pt is None or stato != 'OK' or (m + off) not in rows:
                out.append((f"R274{lett} (+{off}) per-trade vs OOS proprio", False, 'NON MISURABILE (dati mancanti)'))
                continue
            s, n = sum(g.cent(r['net_profit']) for r in pt), len(pt)
            pb, tb = rows[m + off]['Profit'], rows[m + off]['Trades']
            ok = s == g.cent(pb) and n == int(float(tb))
            out.append((f"R274{lett} (+{off}) per-trade vs OOS proprio", ok,
                        f"somma {s / 100:.2f} / {n} deal contro {pb} / {tb} -> {'IDENTICI' if ok else 'SCARTO (non ammesso)'}"))
    for la, lb in G2_COPPIE:
        for off in (0, 50):
            pt = dati['pt'].get((la, FILES[la][2] + off))
            stato, rows = dati['csv'][(lb, 'IS')]
            mb = FILES[lb][2] + off
            if pt is None or stato != 'OK' or mb not in rows:
                out.append((f"R274{la} (+{off}) per-trade vs gamba IS di R274{lb}", False, 'NON MISURABILE (dati mancanti)'))
                continue
            s, n = sum(g.cent(r['net_profit']) for r in pt), len(pt)
            pb, tb = rows[mb]['Profit'], rows[mb]['Trades']
            ok = s == g.cent(pb) and n == int(float(tb))
            out.append((f"R274{la} (+{off}) per-trade vs gamba IS di R274{lb}", ok,
                        f"somma {s / 100:.2f} / {n} deal contro {pb} / {tb} -> "
                        + ('IDENTICI' if ok else "SCARTO: ammesso SOLO se dovuto al 26/09/2024 (l'IS di B parte un giorno prima; "
                           "il per-trade A non lo contiene): si dichiara lo scarto e si usa il per-trade A")))
    return out


# ---------------------------------------------------------------- S1
def s1(dati, lett):
    """(esito, note, gialli). VERDE/GIALLO/ROSSO come in R274a par. 3 (S1)."""
    orol, fin, m = FILES[lett]
    lo, hi = S1[orol]
    pt = dati['pt'].get((lett, m))
    if pt is None or not pt:
        return 'ROSSO', ['per-trade mancante o vuoto: sentinella NON misurabile'], []
    ore = [g.ora(r) for r in pt]
    n = len(ore)
    prima = [r['close_time'] for r in pt if g.ora(r) < lo]
    dopo = [r['close_time'] for r in pt if hi < g.ora(r) < RIAPERTURA]
    gialli = [r['close_time'] for r in pt if g.ora(r) >= RIAPERTURA]
    note = [f"uscite prima delle {lo[:5]}: {len(prima)}/{n}", f"fra {hi[:5]} (escluso) e le 22:59: {len(dopo)}/{n}",
            f"alle 23:00 o dopo (riapertura): {len(gialli)}/{n}", f"min {min(ore)} max {max(ore)}"]
    ident = False
    if orol == 'd1':
        ref = {'b': 'a', 'd': 'c'}[lett]
        p0 = dati['pt'].get((ref, FILES[ref][2]))
        ident = p0 is not None and senza_magic(pt) == senza_magic(p0)
        note.append(f"per-trade identico a R274{ref} (pin d'orario non arrivato): {'SI' if ident else 'no'}")
    if prima or dopo or ident:
        return 'ROSSO', note, gialli
    if gialli:
        return 'GIALLO', note, gialli
    return 'VERDE', note, gialli


# ---------------------------------------------------------------- misure
def celle(dati, off):
    """{(orologio, finestra): per-trade} per la gemella m+off; None se manca"""
    out = {}
    for lett, (orol, fin, m) in FILES.items():
        out[(orol, fin)] = dati['pt'].get((lett, m + off))
    return out


def lato(r):
    return {'1': 'LONG', '0': 'SHORT'}.get(str(r.get('deal_type', '')).strip(), '?')


def tassi(cl):
    """aggregati USA per cella; cl = {(orol, fin): pt}. Ritorna dict con tassi e verdetto."""
    fer = feriali_AB('USA')
    ag = {}
    for orol in ('d0', 'd1'):
        ag[orol] = g.aggrega([(f, cl[(orol, f)]) for f in ('A', 'B')], 'USA')
    r = dict(fer=fer, ag=ag)
    r['rw0'], r['rs0'] = ag['d0']['I']['pos'] / fer['I'], ag['d0']['E']['pos'] / fer['E']
    r['rw1'], r['rs1'] = ag['d1']['I']['pos'] / fer['I'], ag['d1']['E']['pos'] / fer['E']
    r['Df'] = r['rw0'] - r['rs0']
    r['Qf2'] = (r['rw0'] - r['rw1']) / r['Df'] if r['Df'] else float('nan')
    r['verdetto'] = zona(r['Qf2']) if r['Df'] >= SOGLIA_DF else 'DIVARIO NON RIPRODOTTO'
    return r


def serie_ftmo(cl):
    """d0 nei giorni UE d'ESTATE + d+1 nei giorni UE d'INVERNO (calendario UE, come FTMO)."""
    tutti = []
    for f in ('A', 'B'):
        for r in cl[('d0', f)]:
            if not rb.inverno(g.giorno(r), 'UE'):
                tutti.append(((f, 'd0', r['position_id']), r))
        for r in cl[('d1', f)]:
            if rb.inverno(g.giorno(r), 'UE'):
                tutti.append(((f, 'd1', r['position_id']), r))
    fer = feriali_AB('UE')
    nfer = fer['E'] + fer['I']
    deal = [g.cent(r['net_profit']) / 100.0 for _, r in tutti]
    pos = {k for k, _ in tutti}
    seq = sorted([r for _, r in tutti], key=lambda r: r['close_time'])
    dd, ddp = g.dd_saldo(seq, DEP)
    return dict(pf=rb.pf(deal) if deal else 0.0, pos=len(pos), deal=len(deal), netto=sum(deal), dd=dd,
                ddp=ddp * 100.0, fer=nfer, per_g=len(pos) / nfer)


def esito_R2(per_g):
    return ('R2: frequenza SOTTO il promesso (< %.2f pos/feriale su %.2f): revisione di Claudio' % (R2_SOGLIA, R2_PROMESSO)
            if per_g < R2_SOGLIA else 'R2: frequenza non sotto la soglia di 0,25')


def esito_R1(ddp):
    if ddp > DD_MURO:
        return 'R1: DD di saldo > 10%: la sedia come operera\' d\'inverno VIOLA IL MURO -> revisione IMMEDIATA'
    if ddp > DD_CONTRATTO:
        return 'R1: ZONA GRIGIA 7,86% < DD <= 10% = SOPRA IL CONTRATTO -> in TESTA al verdetto, revisione di Claudio'
    return 'R1: DD di saldo entro il contratto (<= 7,86%; contratto 7,31% IS / 7,86% OOS); il DD di saldo e\' un PAVIMENTO dell\'Equity DD'


def per_lato(cl):
    """DESCRITTIVO: posizioni e netto per orologio x stagione USA x lato (nessun verdetto di lato)."""
    out = collections.defaultdict(lambda: [set(), 0])
    for orol in ('d0', 'd1'):
        for f in ('A', 'B'):
            for r in cl[(orol, f)]:
                z = g.stagione(g.giorno(r), 'USA')
                k = (orol, z, lato(r))
                out[k][0].add((f, r['position_id']))
                out[k][1] += g.cent(r['net_profit'])
    return {k: (len(v[0]), v[1] / 100.0) for k, v in out.items()}


def jackknife(cl):
    """DESCRITTIVO: si toglie UNA posizione alla volta e si rifa il verdetto; quanto dista dalla soglia"""
    base = tassi(cl)['verdetto']
    qs, cam = [], 0
    for key in cl:
        for pid in sorted({x['position_id'] for x in cl[key]}):
            c2 = dict(cl)
            c2[key] = [x for x in cl[key] if x['position_id'] != pid]
            v = tassi(c2)
            qs.append(v['Qf2'])
            cam += v['verdetto'] != base
    qs = [q for q in qs if q == q]
    return dict(n=len(qs), qmin=min(qs) if qs else float('nan'), qmax=max(qs) if qs else float('nan'), cam=cam)


# ---------------------------------------------------------------- giudizio
def giudica(dati):
    """ritorna un dict con tutti i cancelli e (se G0 non e' rosso) le misure"""
    R = dict(dati=dati)
    R['g1'] = {l: g1(dati, l) for l in FILES}
    R['ora'] = {l: gate_ora(dati, l) for l in FILES}
    R['g0'] = g0(dati)
    R['g2'] = g2(dati)
    R['s1'] = {l: s1(dati, l) for l in FILES}
    R['nulli'] = sorted(l for l in FILES if R['g1'][l][0] != 'PASS' or R['ora'][l][0] != 'OK'
                        or R['s1'][l][0] == 'ROSSO')
    R['g2_ko'] = [e for e in R['g2'] if not e[1] and 'proprio' in e[0]]
    R['stop'] = R['g0'][0] == 'ROSSO'
    R['misure'] = {}
    if not R['stop']:
        for off in (0, 50):
            cl = celle(dati, off)
            if any(v is None for v in cl.values()):
                continue
            R['misure'][off] = dict(cl=cl, t=tassi(cl), ftmo=serie_ftmo(cl), lato=per_lato(cl), jk=jackknife(cl))
    return R


def stampa(R):
    dati = R['dati']
    print('=' * 78)
    print('R274 -- OROLOGIO DELLA 770260 -- GIUDIZIO COI CRITERI CONGELATI (R274a par. 3-6)')
    print('=' * 78)
    print("\n### 1. G1 DETERMINISMO (alla lettera) + colonna InpSessionHour")
    for l, (orol, fin, m) in FILES.items():
        e, diff = R['g1'][l]
        eo, ko, ril = R['ora'][l]
        print(f"  R274{l} {orol} {fin} magic {m}/{m + 50}: G1 {e} | ora CSV {eo}")
        for d in diff + ko:
            print(f"        - {d}")
        for d in ril:
            print(f"        rilievo: {d}")
        if fin == 'A' and dati['csv'][(l, 'IS')][0] != 'OK':
            print(f"        (CSV _IS {dati['csv'][(l, 'IS')][0]}: ATTESO sulla finestra A, falso allarme)")
    print("\n### 2. G0 RIPRODUZIONE (R274a contro R199B Pass=2, tolleranza di banco)")
    print(f"  -> G0 {R['g0'][0]}")
    for t in R['g0'][1]:
        print(f"        {t}")
    if R['stop']:
        print("\n  *** G0 ROSSO: il round e' NON CONFRONTABILE. Ci si ferma e si cerca cio che balla"
              " (binario, deposito, magic). Nessun verdetto, nessun tasso. ***")
        return
    print("\n### 3. G2 COERENZA FRA FINESTRE")
    for et, ok, t in R['g2']:
        print(f"  {et}: {t}")
    print("\n### 4. S1 SENTINELLA DELL'OROLOGIO (la manopola deve MORDERE)")
    for l, (orol, fin, m) in FILES.items():
        e, note, gialli = R['s1'][l]
        print(f"  R274{l} {orol} {fin}: S1 {e}  | " + '; '.join(note))
        if gialli:
            print(f"        GIALLO: uscite alle 23:00 o dopo, da leggere a mano: {', '.join(gialli[:20])}")
    print("  -> file NULLI (G1, ora CSV o S1 ROSSO):", ['R274' + l for l in R['nulli']] or 'nessuno')
    if R['g2_ko']:
        print("  -> G2: per-trade NON uguale alla gamba OOS del proprio CSV in:", [e[0] for e in R['g2_ko']])
    sospesa = bool(R['nulli'] or R['g2_ko'])
    if sospesa:
        print("  *** LETTURA SOSPESA: almeno un file e' NULLO; si stampa con la prova di invarianza"
              " (gemella +50), la decisione e' di Claudio ***")
    print("\n### 5. VERDETTI (aperti SOLO ora) -- posizioni per feriale, stagione USA della DATA DI CHIUSURA")
    if not R['misure']:
        print("  per-trade mancanti: NON MISURATO")
        return
    for off in (0, 50):
        if off not in R['misure']:
            print(f"  gemella +{off}: per-trade mancanti, NON MISURATO")
            continue
        M = R['misure'][off]
        t, cl = M['t'], M['cl']
        if off == 0:
            fer = t['fer']
            print(f"  feriali A+B (USA): estate {fer['E']}, inverno {fer['I']}"
                  f"  (attesi {N_FERIALI_ATTESI['USA'][0]} / {N_FERIALI_ATTESI['USA'][1]})")
            for orol in ('d0', 'd1'):
                for z, zz in (('E', 'estate '), ('I', 'inverno')):
                    a = t['ag'][orol][z]
                    print(f"  {orol} {zz}: posizioni {a['pos']:3d}  deal {a['deal']:3d}  PF {a['pf']:.3f} [non decide]  netto {a['netto']:10.2f}")
            for f in ('A', 'B'):
                ga = {o: g.aggrega([(f, cl[(o, f)])], 'USA') for o in ('d0', 'd1')}
                print(f"  inverno {f} separato: d0 {ga['d0']['I']['pos']} pos, d+1 {ga['d1']['I']['pos']} pos"
                      f" | estate: d0 {ga['d0']['E']['pos']}, d+1 {ga['d1']['E']['pos']}  [DESCRITTIVO]")
            print(f"  TASSI: r_w0 {t['rw0']:.4f}  r_s0 {t['rs0']:.4f}  Df {t['Df']:.4f} (soglia {SOGLIA_DF})"
                  f"  r_w1 {t['rw1']:.4f}  (r_s1 {t['rs1']:.4f} descrittivo)")
            print(f"  Qf2 = (r_w0 - r_w1) / Df = {t['Qf2']:.3f}  -> {t['verdetto']}   (>= 0,70 OROLOGIO, <= 0,30 STAGIONE)")
            pw1 = t['ag']['d1']['I']['pos']
            print(f"  posizioni d+1 d'inverno {pw1}: bande congelate H_STAGIONE {BANDE_POS[0]} / H_OROLOGIO {BANDE_POS[1]} -> "
                  f"{g.dove_cade(pw1, BANDE_POS)}")
            print(f"  attese RICALCOLATE dai tassi veri di d0: H_ORA = r_s0 x {t['fer']['I']} = {t['rs0'] * t['fer']['I']:.1f};"
                  f" H_STAGIONE = r_w0 x {t['fer']['I']} = {t['rw0'] * t['fer']['I']:.1f}")
            jk = M['jk']
            print(f"  fragilita' (jackknife, {jk['n']} posizioni): Qf2 [{jk['qmin']:.3f} ; {jk['qmax']:.3f}], verdetto cambia in {jk['cam']}  [DESCRITTIVO]")
            f = M['ftmo']
            print(f"  SERIE COME LA VEDREBBE FTMO [INFERITA] (d0 nei giorni UE d'estate + d+1 nei giorni UE d'inverno, {f['fer']} feriali):"
                  f" posizioni {f['pos']} ({f['per_g']:.3f}/feriale)  deal {f['deal']}  PF {f['pf']:.3f} [non decide]  netto {f['netto']:.2f}"
                  f"  DD di saldo {f['dd']:.2f} EUR = {f['ddp']:.2f}% (lotti NON ricalcolati [DERIVATO])")
            print(f"    {esito_R2(f['per_g'])}")
            print(f"    {esito_R1(f['ddp'])}")
            print("  PER LATO [DESCRITTIVO, nessun verdetto di lato] posizioni / netto, stagione USA:")
            for k in sorted(M['lato']):
                n, net = M['lato'][k]
                print(f"    {k[0]} {'estate ' if k[1] == 'E' else 'inverno'} {k[2]:5s}: {n:3d} pos  netto {net:10.2f}")
        else:
            t0 = R['misure'][0]['t']
            same = (t['Qf2'], t['verdetto'], t['ag']['d1']['I']['pos']) == (t0['Qf2'], t0['verdetto'], t0['ag']['d1']['I']['pos'])
            print(f"  invarianza gemella +50: Qf2 {t['Qf2']:.6f} -> {t['verdetto']}, posizioni d+1 inverno {t['ag']['d1']['I']['pos']}"
                  f" -> {'INVARIATO' if same else 'CAMBIA'}")
    print("\nPF: si scrive, NON decide (n < 150 per costruzione). Merito SOSPESO, il DD si legge sempre (Emendamento B).")
    print("NON MISURATO: spread e feed FTMO US100.cash, Guardian nel campo, commissione FTMO, settimana 26-30/10/2026, inverni prima del 2024.")


# ---------------------------------------------------------------- autotest
def _giorni(fin, stag, n):
    """n feriali (date) distribuiti nella finestra, stagione USA stag ('E'/'I')"""
    a, b = FIN[fin]
    d, tutti = a, []
    while d <= b:
        if d.weekday() < 5 and ('I' if rb.inverno(d, 'USA') else 'E') == stag:
            tutti.append(d)
        d += dt.timedelta(1)
    assert n <= len(tutti), (fin, stag, n, len(tutti))
    step = len(tutti) / n if n else 1
    return [tutti[int(i * step)] for i in range(n)]


def _pt(lett, n_inv, n_est, n_deal, somma_cent, magic=None, ora_us=None):
    """per-trade sintetico: n_inv + n_est posizioni (un'uscita di base, n_deal totali), somma esatta"""
    orol, fin, m = FILES[lett]
    magic = magic or m
    ora_us = ora_us or ('17:00:00' if orol == 'd0' else '18:00:00')
    date = _giorni(fin, 'I', n_inv) + _giorni(fin, 'E', n_est)
    npos = len(date)
    assert n_deal >= npos
    rows, pid = [], 100
    extra = n_deal - npos
    for i, d in enumerate(date):
        n_us = 2 if i < extra else 1
        for j in range(n_us):
            pid_s = str(pid + i)
            rows.append({'close_time': d.strftime('%Y.%m.%d') + ' ' + ora_us, 'symbol': SIM, 'magic': str(magic),
                         'position_id': pid_s, 'deal_type': str(i % 2), 'volume': '1.00', 'price': '20000.00',
                         'net_profit': ('10.00' if (i + j) % 3 else '-5.00')})
    rows.sort(key=lambda r: r['close_time'])
    cur = sum(g.cent(r['net_profit']) for r in rows[:-1])
    last = somma_cent - cur
    rows[-1]['net_profit'] = '%s%d.%02d' % ('-' if last < 0 else '', abs(last) // 100, abs(last) % 100)
    return rows


def _csv_row(magic, hour, profit, pf, rf, dd, trades):
    return {'InpMagic': str(magic), 'InpSessionHour': str(hour), 'InpSessionMin': '30', 'InpCloseHour': '17',
            'Profit': profit, 'Profit Factor': pf, 'Recovery Factor': rf, 'Equity DD %': dd, 'Trades': str(trades)}


def sintetico(w1_inv=61, w1_est=40):
    """round sintetico COERENTE: a = R199B (102 pos/172 deal OOS), c = IS di R199B (82 pos/135 deal).
    d0 inverno = 45 (A) + 45 (B) = 90 pos (r_w0 0,500); d0 estate = 37 + 57 = 94 (r_s0 0,338): Df 0,162.
    b/d (d+1): w1_inv posizioni d'inverno totali (meta' A, meta' B)."""
    dati = dict(csv={}, pt={}, root='(sintetico)')
    base = {
        'a': (45, 57, 172, g.cent('8496.74')), 'c': (45, 37, 135, g.cent('7014.20')),
        'b': (w1_inv - w1_inv // 2, w1_est, 150, 5000_00), 'd': (w1_inv // 2, w1_est, 100, 3000_00),
    }
    for lett, (ni, ne, nd, tot) in base.items():
        orol, fin, m = FILES[lett]
        for tw in (m, m + 50):
            dati['pt'][(lett, tw)] = _pt(lett, ni, ne, nd, tot, magic=tw)
    h = ORA_CSV
    for lett, (orol, fin, m) in FILES.items():
        if lett == 'a':
            os_ = ('8496.74', '1.21546', '1.29687', '7.8576', 172)
        else:
            tot = sum(g.cent(r['net_profit']) for r in dati['pt'][(lett, m)])
            os_ = ('%d.%02d' % (tot // 100, tot % 100), '1.20000', '1.10000', '5.0000', len(dati['pt'][(lett, m)]))
        dati['csv'][(lett, 'OOS')] = ('OK', {mg: _csv_row(mg, h[orol], *os_) for mg in (m, m + 50)})
    # IS: a = R199B; b = per-trade di d; A (c, d): vuoto atteso
    dati['csv'][('a', 'IS')] = ('OK', {mg: _csv_row(mg, 14, '7014.20', '1.22116', '1.14977', '7.3069', 135) for mg in (798201, 798251)})
    tot_d = sum(g.cent(r['net_profit']) for r in dati['pt'][('d', 798212)])
    dati['csv'][('b', 'IS')] = ('OK', {mg: _csv_row(mg, 15, '%d.%02d' % (tot_d // 100, tot_d % 100), '1.1', '1.1', '5.0',
                                                    len(dati['pt'][('d', 798212)])) for mg in (798211, 798261)})
    dati['csv'][('c', 'IS')] = ('VUOTO', {})
    dati['csv'][('d', 'IS')] = ('VUOTO', {})
    return dati


def autotest():
    # --- calendario: i conteggi dichiarati in R274a par. 1
    for cal, (e, i) in N_FERIALI_ATTESI.items():
        f = feriali_AB(cal)
        assert (f['E'], f['I']) == (e, i), (cal, f)
    assert feriali_AB('USA')['E'] + feriali_AB('USA')['I'] == 458 == feriali_AB('UE')['E'] + feriali_AB('UE')['I']
    assert (feriali_AB('USA')['BE'] + feriali_AB('USA')['BI'], feriali_AB('USA')['AE'] + feriali_AB('USA')['AI']) == (276, 182)
    # --- zone
    assert zona(0.70) == 'OROLOGIO' and zona(0.30) == 'STAGIONE' and zona(0.5).startswith('MISTO')
    # --- scenario pulito: OROLOGIO (d+1 d'inverno ~ d0 d'estate)
    d = sintetico(61)
    R = giudica(d)
    assert R['g0'][0] == 'VERDE', R['g0']
    assert all(R['g1'][l][0] == 'PASS' for l in FILES), R['g1']
    assert all(R['ora'][l][0] == 'OK' for l in FILES)
    assert all(ok for _, ok, t in R['g2'] if 'gamba IS' in _ or 'proprio' in _), R['g2']
    assert all(R['s1'][l][0] == 'VERDE' for l in FILES), R['s1']
    assert R['nulli'] == [], R['nulli']
    t0 = R['misure'][0]['t']
    assert abs(t0['rw0'] - 90 / 180) < 1e-9 and abs(t0['rs0'] - 94 / 278) < 1e-9, t0
    assert t0['verdetto'] == 'OROLOGIO', t0
    assert R['misure'][0]['t']['Qf2'] == R['misure'][50]['t']['Qf2']
    f = R['misure'][0]['ftmo']
    assert f['fer'] == 458 and f['pos'] > 0 and f['ddp'] >= 0
    stampa(R)  # non deve sollevare
    # --- STAGIONE: d+1 d'inverno ~ d0 d'inverno
    assert giudica(sintetico(90))['misure'][0]['t']['verdetto'] == 'STAGIONE'
    # --- MISTO
    assert giudica(sintetico(75))['misure'][0]['t']['verdetto'].startswith('MISTO')
    # --- Df < 0,15: divario non riprodotto (d0 estate piu' alta)
    d2 = sintetico(61)
    for tw in (798201, 798251):
        d2['pt'][('a', tw)] = _pt('a', 45, 80, 172, g.cent('8496.74'), magic=tw)
    d2['csv'][('a', 'OOS')] = ('OK', {mg: _csv_row(mg, 14, '8496.74', '1.21546', '1.29687', '7.8576', 172) for mg in (798201, 798251)})
    r2 = giudica(d2)
    assert r2['stop'] is True  # 125 posizioni != 102: G0 per-trade ROSSO (blocca prima del verdetto)
    # --- G0: tolleranza di banco
    d3 = sintetico(61)
    for mg in (798201, 798251):
        d3['csv'][('a', 'OOS')][1][mg]['Profit'] = '8497.73'      # +0,99
    assert g0(d3)[0] == 'VERDE'
    for mg in (798201, 798251):
        d3['csv'][('a', 'OOS')][1][mg]['Profit'] = '8497.75'      # +1,01
    assert g0(d3)[0] == 'ROSSO'
    d3 = sintetico(61)
    for mg in (798201, 798251):
        d3['csv'][('a', 'OOS')][1][mg]['Profit Factor'] = '1.21576'   # +0,0003
    assert g0(d3)[0] == 'ROSSO'
    d3 = sintetico(61)
    for mg in (798201, 798251):
        d3['csv'][('a', 'OOS')][1][mg]['Equity DD %'] = '7.8577'     # DD deve essere ESATTO
    assert g0(d3)[0] == 'ROSSO'
    d3 = sintetico(61)
    for mg in (798201, 798251):
        d3['csv'][('a', 'IS')][1][mg]['Trades'] = '136'
    assert g0(d3)[0] == 'ROSSO'
    # G0 ROSSO ferma tutto: nessuna misura
    assert giudica(d3)['misure'] == {} and giudica(d3)['stop'] is True
    # --- G1: un centesimo di differenza nel per-trade della gemella -> NULLO
    d4 = sintetico(61)
    d4['pt'][('b', 798261)][3] = dict(d4['pt'][('b', 798261)][3], net_profit='10.01')
    assert g1(d4, 'b')[0] == 'NULLO' and g1(d4, 'a')[0] == 'PASS'
    # ... CSV OOS senza Trades>0 -> NULLO su QUALUNQUE finestra
    d4 = sintetico(61)
    for mg in (798202, 798252):
        d4['csv'][('c', 'OOS')][1][mg]['Trades'] = '0'
    assert g1(d4, 'c')[0] == 'NULLO'
    # ... CSV _IS vuoto sulle A e' ATTESO, ma vuoto sulle B e' guasto
    assert g1(sintetico(61), 'c')[0] == 'PASS'
    d4 = sintetico(61)
    d4['csv'][('b', 'IS')] = ('VUOTO', {})
    assert g1(d4, 'b')[0] == 'NULLO'
    # --- colonna ora: 15 nel file d0 -> file NULLO (CSV da cestinare)
    d5 = sintetico(61)
    for mg in (798201, 798251):
        d5['csv'][('a', 'OOS')][1][mg]['InpSessionHour'] = '15'
    assert gate_ora(d5, 'a')[0] == 'NULLO' and 'a' in giudica(d5)['nulli']
    d5 = sintetico(61)
    for mg in (798211, 798261):
        d5['csv'][('b', 'OOS')][1][mg]['InpSessionHour'] = '14'
    assert gate_ora(d5, 'b')[0] == 'NULLO'
    # --- G2: scarto fra per-trade A e gamba IS di B
    d6 = sintetico(61)
    for mg in (798201, 798251):
        d6['csv'][('a', 'IS')][1][mg]['Trades'] = '136'
    e = [x for x in g2(d6) if x[0].startswith('R274c (+0)') and 'gamba IS' in x[0]][0]
    assert e[1] is False and '26/09/2024' in e[2]
    assert all(x[1] for x in g2(sintetico(61)))
    # --- S1: uscite fuori finestra
    d7 = sintetico(61)
    d7['pt'][('a', 798201)][0] = dict(d7['pt'][('a', 798201)][0], close_time=d7['pt'][('a', 798201)][0]['close_time'][:11] + '15:04:00')
    assert s1(d7, 'a')[0] == 'ROSSO'
    d7 = sintetico(61)
    d7['pt'][('a', 798201)][0] = dict(d7['pt'][('a', 798201)][0], close_time=d7['pt'][('a', 798201)][0]['close_time'][:11] + '17:32:00')
    assert s1(d7, 'a')[0] == 'ROSSO'
    d7['pt'][('a', 798201)][0] = dict(d7['pt'][('a', 798201)][0], close_time=d7['pt'][('a', 798201)][0]['close_time'][:11] + '17:31:00')
    assert s1(d7, 'a')[0] == 'VERDE'                      # 17:31 e' il bordo, non e' dopo
    d7['pt'][('a', 798201)][0] = dict(d7['pt'][('a', 798201)][0], close_time=d7['pt'][('a', 798201)][0]['close_time'][:11] + '23:10:00')
    assert s1(d7, 'a')[0] == 'GIALLO' and len(s1(d7, 'a')[2]) == 1   # riapertura dopo la pausa: da leggere a mano
    d7 = sintetico(61)
    d7['pt'][('b', 798211)][0] = dict(d7['pt'][('b', 798211)][0], close_time=d7['pt'][('b', 798211)][0]['close_time'][:11] + '16:04:00')
    assert s1(d7, 'b')[0] == 'ROSSO'
    d7 = sintetico(61)
    d7['pt'][('b', 798211)][0] = dict(d7['pt'][('b', 798211)][0], close_time=d7['pt'][('b', 798211)][0]['close_time'][:11] + '18:32:00')
    assert s1(d7, 'b')[0] == 'ROSSO'
    # --- S1: il per-trade d+1 identico al d0 (pin d'orario non arrivato) -> ROSSO
    d8 = sintetico(61)
    d8['pt'][('b', 798211)] = [dict(r, magic='798211') for r in d8['pt'][('a', 798201)]]
    assert s1(d8, 'b')[0] == 'ROSSO' and any('SI' in n for n in s1(d8, 'b')[1])
    # --- R2 / R1: bordi congelati
    assert 'SOTTO' in esito_R2(0.249) and 'non sotto' in esito_R2(0.25)
    assert 'ZONA GRIGIA' in esito_R1(7.87) and 'entro il contratto' in esito_R1(7.86)
    assert 'ZONA GRIGIA' in esito_R1(10.0) and 'VIOLA' in esito_R1(10.01)
    # --- serie FTMO: d0 conta nei giorni UE d'estate, d+1 nei giorni UE d'inverno (e solo li')
    cl = {('d0', 'A'): [], ('d0', 'B'): [], ('d1', 'A'): [], ('d1', 'B'): []}
    cl[('d0', 'A')] = [{'close_time': '2025-01-15'.replace('-', '.') + ' 17:00:00', 'position_id': '1', 'net_profit': '10.00'}]   # UE inverno: NON conta
    cl[('d0', 'B')] = [{'close_time': '2025.07.15 17:00:00', 'position_id': '1', 'net_profit': '-100.00'}]                      # UE estate: conta
    cl[('d1', 'A')] = [{'close_time': '2025.01.15 18:00:00', 'position_id': '1', 'net_profit': '-300.00'}]                      # UE inverno: conta
    cl[('d1', 'B')] = [{'close_time': '2025.07.15 18:00:00', 'position_id': '2', 'net_profit': '50.00'}]                        # UE estate: NON conta
    sf = serie_ftmo(cl)
    assert sf['pos'] == 2 and sf['deal'] == 2 and abs(sf['netto'] + 400.0) < 1e-9, sf
    assert abs(sf['ddp'] - 100.0 * 400 / 80000) < 1e-9, sf      # picco 80000, fondo 79600: 0,5%
    # --- per lato: deal_type 1 = long, 0 = short
    assert lato({'deal_type': '1'}) == 'LONG' and lato({'deal_type': '0'}) == 'SHORT' and lato({'deal_type': 'x'}) == '?'
    # --- lettura da disco (layout della riga) con cartella temporanea
    with tempfile.TemporaryDirectory() as tmp:
        d9 = sintetico(61)
        os.makedirs(os.path.join(tmp, 'PERTRADE'))
        for (lett, mg), rows in d9['pt'].items():
            with open(os.path.join(tmp, 'PERTRADE', f"abtg_trades_{EA}_{SIM}_{mg}.csv"), 'w', newline='') as fh:
                w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()), delimiter=';')
                w.writeheader()
                w.writerows(rows)
        for (lett, gamba), (stato, rows) in d9['csv'].items():
            dd = os.path.join(tmp, 'ROUND_R274' + lett)
            os.makedirs(dd, exist_ok=True)
            p = os.path.join(dd, f"{EA}_{SIM}_{gamba}_R274{lett}.csv")
            if stato == 'OK':
                with open(p, 'w', newline='') as fh:
                    w = csv.DictWriter(fh, fieldnames=list(next(iter(rows.values())).keys()))
                    w.writeheader()
                    w.writerows(rows.values())
            else:
                open(p, 'w').close()           # 0 byte, come il CSV _IS delle finestre A
        dl = carica(tmp)
        assert dl['csv'][('c', 'IS')][0] == 'VUOTO' and dl['csv'][('a', 'OOS')][0] == 'OK'
        rl = giudica(dl)
        assert rl['g0'][0] == 'VERDE' and rl['nulli'] == [] and rl['misure'][0]['t']['verdetto'] == 'OROLOGIO'
        os.remove(os.path.join(tmp, 'PERTRADE', f"abtg_trades_{EA}_{SIM}_798251.csv"))
        assert giudica(carica(tmp))['g1']['a'][0] == 'NULLO'      # per-trade gemella mancante: NULLO, non crash
    print("autotest r274_giudizio: OK")


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        autotest()
    elif len(sys.argv) >= 2 and os.path.isdir(sys.argv[1]):
        stampa(giudica(carica(sys.argv[1])))
    else:
        print("uso: python3 backtest_pipeline/r274_giudizio.py <cartella ROUND_R274_data>   |   --autotest")
        sys.exit(2)
