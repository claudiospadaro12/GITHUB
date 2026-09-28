#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_r255.py -- LA LETTURA DI R255 (il lato short dell'apertura Dow a due
orologi) dalla raccolta ROUND_R255_SHORT_DOW_INFASE_<data>/ della riga
backtest_pipeline/righe/RIGA_R255_SHORT_DOW_INFASE.txt (PASS 0fdb1a9c).

Applica i criteri CONGELATI PRIMA DEI NUMERI del file di testa
prove/R255a_short_DOW_ancora_1430.txt, par. 7-17. Niente a memoria: ogni
numero viene dai 48 per-trade, dai CSV _OOS, dai due archivi R246
(794603/794601) e dal RIEPILOGO_R255.txt (che si RILEGGE, non si crede).

Cosa fa, per ognuna delle 12 configurazioni (ancora, nudo, parz0, tp05,
tp15, trail0, stH4, stH6, stH8, stH12, stD1, long) x 2 orologi (14:30 /
15:30):
  PRE-LETTURA per file (par. 8): E0 (CSV _OOS a 2 righe con Trades > 0),
    P0 (pin del file prova nel CSV, numerici e bool, InpMagic = gemella),
    G1 (gemelle identiche nei campi che decidono e per-trade riga per riga),
    C0 (per-trade = Trades, somma = Profit entro 0,05, prima chiusura >=
    2024.09.27), L0 (lato dei deal), S1 (ora BCM di chiusura nella finestra
    dell'orologio). Un file che fallisce = NULLO, la configurazione = NULLA.
    Il moncone IS del 2024.09.26 si riporta (vuoto = ATTESO).
  G0-LONG (R255w contro r6 74/260,71 e archivi 794603/794601), G0-ANCORA
    (R255a contro R54a 73/73), G0-SOTTOINSIEME (ancora e stXX dentro il
    nudo dello stesso orologio), G0-INGRESSI (uscite = stesse giornate
    dell'ancora), G2 (le manopole mordono, orologio compreso): la riga li
    stampa nel RIEPILOGO come pre-lettura; qui si RICALCOLANO dai per-trade
    e dai CSV, e si scrive se la riga e il per-trade dicono cose diverse.
  TRE CURVE (par. 7), per era (IS 2024.09.27-2025.06.09, OOS 2025.06.10-
    2026.06.30, per data di chiusura), dai per-trade della gemella g1:
    IN FASE   = estate USA dal file 14:30 + inverno USA dal file 15:30
                (inverno USA [2024.11.03, 2025.03.09) e [2025.11.02,
                2026.03.08); i 40 feriali "UE solare / USA legale" sono
                ESTATE per il Dow sul BCM). E' la curva che DECIDE.
    CONTROLLO = tutto il file 14:30 (il BCM a ora fissa).
    FTMO-DOC  = IN FASE, ma i 40 feriali di disallineamento dal file 15:30.
                DESCRITTIVA (regola documentata e non misurata di FTMO).
    Metodo A (ribasato: r = net / saldo della SUA corsa prima della
    posizione, curva che riparte da 10000 per era) e metodo B (denaro),
    TUTTI E DUE riportati. Per curva ed era: posizioni, deal, Profit, PF
    per posizione e sui deal, EP, DD a saldo chiuso (EUR e % di 10000,
    classe 550), peggior giornata a saldo chiuso col denominatore = saldo
    della curva a INIZIO giornata (par. 9), serie perdente (riportata, non
    cancello), scarto di saldo corsa/curva, sedute di confine (classe 805).
  e_eff = max(e_IS, e_OOS, 0,1266), con e misurato sul LONG: DD metodo A
    di R255w (era IS) contro 794603 e (era OOS) contro 794601. G0-LONG
    ROSSO -> e_IS/e_OOS illeggibili, e_eff = 0,1266.
  R1 (DD IS <= 4,694%) / R2 (DD OOS <= 4,272%) sulla curva IN FASE:
    VIOLATO se min(A,B) x (1-e_eff) > S; RISPETTATO se max(A,B) x
    (1+e_eff) <= S; NON RISOLTO altrimenti (e d'ufficio se lo scarto di
    saldo > 10% e il DD sta fra 0,8 e 1,2 volte S). R3 (peggior giornata
    >= -1,10% in tutte e due le ere, metodi A e B): la "Peggior Giornata
    %" del CSV _OOS >= -1,10 e' condizione sufficiente SOLO per il metodo
    A; il B si calcola SEMPRE, e A rispetta + B viola = VIOLATO con lo
    scarto di saldo di quella giornata accanto (classe 833).
  VERDETTO ASIMMETRICO (classe 804): una violazione boccia a qualunque n;
    "RISCHIO PASSATO" solo con n IS >= 60 (R1) e n OOS >= 40 (R2),
    altrimenti "NON VIOLATO su n = X" con la P che un motore senza edge
    lo passi (tabella EV 0 del par. 9). Rischio letto anche sul CONTROLLO
    (un fatto per QUELLA sedia). "EQUITY PEGGIO DEL LONG" accanto a R1/R2
    se il DD_fisso del CSV _OOS del file 14:30 supera quello di R255w.
  MERITO (par. 10): SOSPESO sotto 150 posizioni OOS in fase; M1-M3 si
    calcolano comunque (riferimento per configurazione) e sotto 150 al
    massimo "INDIZIO FAVOREVOLE, merito sospeso". M4 altopiano (Supertrend:
    3 celle contigue, la centrale, pari -> la piu' vicina a H8; TP1_R: solo
    1,0 puo' essere un centro; interruttori: nessun altopiano).
  ESITI nell'ordine del par. 10: NULLO, NON ESEGUITA, NON LEGGIBILE, [NON
    CONFRONTABILE], BOCCIATA PER RISCHIO, RISCHIO NON RISOLTO, SOSPESA,
    BOCCIATA PER MERITO, PROMOSSA AL PASSO DOPO.
  RISCALDAMENTO (classe 834): posizioni dell'era IS nelle prime barre senza
    filtro dei Supertrend (H4 ~3, H6 ~4, H8 ~5, H12 ~8, D1 ~15 feriali) e
    dell'EMA 50 H4 (~9 feriali), riportate col loro P/L.
  VALORE DEL PUNTO dal per-trade (posizioni a due deal, ingresso eliminato:
    r253_referto.valore_punto) e stop mediano: DESCRITTIVI (par. 12).
  "COSA DICE PER LA 770212": la curva FTMO-DOC della configurazione ANCORA
    (= la sedia in firma), descrittiva, con R1/R2/R3 letti sopra.
  NESSUNA PROPOSTA DI TAGLIA. Nessun preset, EA, sedia o conto toccato.

USO:
  python3 backtest_pipeline/leggi_r255.py --raccolta <cartella ROUND_R255_SHORT_DOW_INFASE_AAAA-MM-GG>
        [--out referto.txt] [--s1-festivi]
     --s1-festivi (DEFAULT SPENTA): LETTURA B, S1 EMENDATA DOPO I NUMERI, IN ATTESA DELLA FIRMA DI CLAUDIO
       (classe 900). Esenta per nome le uscite fuori finestra alla riapertura CME dopo un festivo USA
       ELENCATO (FESTIVI_ESENTI), al massimo 2 per per-trade; tutto il resto resta NULLO. Senza l opzione
       l output e IDENTICO AL BYTE alla lettura A.
  python3 backtest_pipeline/leggi_r255.py --autotest   [--fixture-dir DIR]
     (fixture dagli archivi VERI 794603/794601: long = R246 al centesimo,
      short = righe invertite di segno e date spostate; casi: pulito,
      R2 violato, R3 violato solo nel metodo B, n < 40, moncone IS vuoto /
      moncone che ha operato)
"""
import argparse
import collections
import csv
import datetime as dt
import hashlib
import math
import os
import re
import shutil
import statistics as st
import sys
import tempfile

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
try:
    from r253_referto import valore_punto as _valore_punto_r253   # modello di codice: riuso dichiarato
except Exception:   # pragma: no cover
    _valore_punto_r253 = None

EA, SIMB = 'ABTG_Dow_Apertura_US', 'U30USD'
DEPOSITO = 10000.0
EPS = 0.000001                    # classe 794
INV_USA = [(dt.date(2024, 11, 3), dt.date(2025, 3, 9)), (dt.date(2025, 11, 2), dt.date(2026, 3, 8))]
INV_UE = [(dt.date(2024, 10, 27), dt.date(2025, 3, 30)), (dt.date(2025, 10, 26), dt.date(2026, 3, 29))]
ERE = collections.OrderedDict([('IS', (dt.date(2024, 9, 27), dt.date(2025, 6, 9))),
                               ('OOS', (dt.date(2025, 6, 10), dt.date(2026, 6, 30)))])
CONFINE_15 = {dt.date(2024, 11, 4), dt.date(2025, 11, 3)}     # primo feriale d'inverno (dal file 15:30)
CONFINE_14 = {dt.date(2025, 3, 10), dt.date(2026, 3, 9)}      # primo feriale d'estate (dal file 14:30)
R1_MAX, R2_MAX, R3_MIN = 4.694, 4.272, -1.10                  # par. 9, a saldo chiuso
E_MIN = 0.1266                                                # par. 7, banda p99 lotti d'inverno x0,55 scarto 10%
N_R1, N_R2, N_MERITO = 60, 40, 150                            # classe 804 / par. 10
G0_LONG = dict(deal_is=74, sum_is=260.71, tol_giallo=2.61, deal_oos=130)
G0_ANCORA = dict(deal_is=73, deal_oos=73)
# par. 9, classe 804: P(un motore SENZA edge rispetti il tetto) a n posizioni, riga EV 0, seme 255
P_R1 = {20: 0.83, 30: 0.67, 40: 0.55, 60: 0.35, 80: 0.24, 100: 0.15}
P_R2 = {20: 0.77, 30: 0.61, 40: 0.47, 60: 0.28, 80: 0.17, 100: 0.10}
RISCALDA = {'stH4': 3, 'stH6': 4, 'stH8': 5, 'stH12': 8, 'stD1': 15, 'ancora': 9}   # feriali, classe 834
ST_ORDINE = ['stH4', 'stH6', 'stH8', 'stH12', 'stD1']

# la famiglia (testa par. 2): configurazione -> (file 14:30, file 15:30), magic (g1, g2) per file, lato
CONF = collections.OrderedDict([
    ('ancora', ('R255a', 'R255b')), ('nudo', ('R255c', 'R255d')), ('parz0', ('R255e', 'R255f')),
    ('tp05', ('R255g', 'R255h')), ('tp15', ('R255i', 'R255j')), ('trail0', ('R255k', 'R255l')),
    ('stH4', ('R255m', 'R255n')), ('stH6', ('R255o', 'R255p')), ('stH8', ('R255q', 'R255r')),
    ('stH12', ('R255s', 'R255t')), ('stD1', ('R255u', 'R255v')), ('long', ('R255w', 'R255x'))])
RIF = {'ancora': ('ancora', 'CONTROLLO'), 'nudo': ('ancora', 'IN FASE'), 'parz0': ('ancora', 'IN FASE'),
       'tp05': ('ancora', 'IN FASE'), 'tp15': ('ancora', 'IN FASE'), 'trail0': ('ancora', 'IN FASE'),
       'stH4': ('nudo', 'IN FASE'), 'stH6': ('nudo', 'IN FASE'), 'stH8': ('nudo', 'IN FASE'),
       'stH12': ('nudo', 'IN FASE'), 'stD1': ('nudo', 'IN FASE'), 'long': None}
USCITE = ('parz0', 'tp05', 'tp15', 'trail0')
FILE = collections.OrderedDict()
for _i, (_cf, (_f14, _f15)) in enumerate(CONF.items()):
    _lato = 'long' if _cf == 'long' else 'short'
    for _k, (_f, _ora) in enumerate(((_f14, '1430'), (_f15, '1530'))):
        _m = 793101 + 2 * _i + _k
        FILE[_f] = dict(cf=_cf, ora=_ora, g1=_m, g2=_m + 50, sd=1 if _cf == 'long' else 0,
                        lo='15:05:00' if _ora == '1430' else '16:05:00', hi='17:30:59' if _ora == '1430' else '18:30:59',
                        prova='%s_%s_DOW_%s_%s.txt' % (_f, _lato, _cf, _ora))
assert FILE['R255a']['g1'] == 793101 and FILE['R255x']['g2'] == 793174 and FILE['R255w']['g1'] == 793123
N_PIN = 77                        # pin fissi per file prova (riga: np=77), + l'asse InpMagic
RIGA_R255 = os.path.join(QUI, 'righe', 'RIGA_R255_SHORT_DOW_INFASE.txt')


def sha_pin_dalla_riga():
    """SHA256 dei 24 file prova AL PIN, letti dalla riga (hp=...): classe 873, il lettore verifica la prova che legge"""
    if not os.path.exists(RIGA_R255):
        return {}
    with open(RIGA_R255, encoding='ascii', errors='replace') as fh:
        s = fh.read()
    return {t: hp for t, hp in re.findall(r"t='(R255[a-x])';[^}]*?hp='([0-9A-F]{64})'", s)}


def trova_raccolta(base):
    """classe 872: una cartella sbagliata NON deve diventare 24 file NULLI. Ritorna (cartella vera, nota) o esce."""
    def n_round(d):
        return sum(1 for f in FILE if os.path.isdir(os.path.join(d, 'ROUND_' + f)))
    if n_round(base) > 0:
        return base, ''
    sotto = [os.path.join(base, x) for x in sorted(os.listdir(base)) if os.path.isdir(os.path.join(base, x))]
    buone = [d for d in sotto if n_round(d) > 0]
    if len(buone) == 1:
        return buone[0], 'raccolta trovata UN livello sotto la cartella data: %s' % buone[0]
    raise SystemExit('RACCOLTA NON TROVATA in %s: nessuna cartella ROUND_R255a..ROUND_R255x (ne qui ne un livello sotto; %d candidate). '
                     'Si passa la cartella dello zip SCOMPATTATO, quella che contiene ROUND_R255a\\, PERTRADE\\ e RIEPILOGO_R255.txt. '
                     'Niente referto: 24 file NULLI per un percorso sbagliato sarebbero un falso.' % (base, len(buone)))


def nulli_della_riga(testo):
    """classe 873: gli ESITI della riga nel RIEPILOGO (una riga per file: 'R255a  rc ... FILE NULLO: motivi' o 'file NON nullo')"""
    out = collections.OrderedDict()
    for ln in testo.splitlines():
        m = re.match(r'^(R255[a-x])\s+rc\b', ln)
        if m and m.group(1) in FILE:
            out[m.group(1)] = ln.split('FILE NULLO: ', 1)[1].strip() if 'FILE NULLO: ' in ln else ''
    return out


# ---------------------------------------------------------------- calendario
def inverno_usa(d):
    return any(a <= d < b for a, b in INV_USA)


def inverno_ue(d):
    return any(a <= d < b for a, b in INV_UE)


def era_di(d):
    for k, (a, b) in ERE.items():
        if a <= d <= b:
            return k
    return None


# ---------------------------------------------------------------- LETTURA B (--s1-festivi): S1 EMENDATA DOPO I NUMERI
# Classe 900: questo emendamento e' stato scritto DOPO aver visto i numeri di R255 (19 file NULLI per S1, ognuno per UNA
# uscita alla riapertura CME dopo un festivo USA). Il criterio congelato (testa par. 8) NON cambia: senza --s1-festivi
# il lettore produce la lettura A, identica al byte. La B vale solo con la firma di Claudio.
# Festivi che ESENTANO: solo quelli osservati nei per-trade di R255 come uscite fuori finestra, PER NOME.
FESTIVI_ESENTI = collections.OrderedDict([
    (dt.date(2025, 1, 9), 'lutto nazionale USA (J. Carter), borse chiuse'),
    (dt.date(2025, 6, 19), 'Juneteenth'),
    (dt.date(2026, 5, 25), 'Memorial Day')])
# Festivi CME previsti nella finestra 2024.09.27-2026.06.30 e NON osservati come uscite fuori finestra: si ELENCANO e si
# controllano, ma NON esentano (se uno comparisse, resta NULLO e lo si scrive: va aggiunto per nome con la firma).
FESTIVI_PREVISTI = collections.OrderedDict([
    (dt.date(2024, 11, 28), 'Thanksgiving'), (dt.date(2024, 12, 25), 'Natale'), (dt.date(2025, 1, 1), 'Capodanno'),
    (dt.date(2025, 1, 20), 'Martin Luther King Day'), (dt.date(2025, 2, 17), 'Presidents Day'), (dt.date(2025, 4, 18), 'Venerdi Santo'),
    (dt.date(2025, 5, 26), 'Memorial Day'), (dt.date(2025, 7, 4), 'Independence Day'), (dt.date(2025, 9, 1), 'Labor Day'),
    (dt.date(2025, 11, 27), 'Thanksgiving'), (dt.date(2025, 12, 25), 'Natale'), (dt.date(2026, 1, 1), 'Capodanno'),
    (dt.date(2026, 1, 19), 'Martin Luther King Day'), (dt.date(2026, 2, 16), 'Presidents Day'), (dt.date(2026, 4, 3), 'Venerdi Santo'),
    (dt.date(2026, 6, 19), 'Juneteenth')])
S1B_FINESTRA = dt.timedelta(minutes=90)     # (b) prima ora e mezza dalla riapertura CME
S1B_MAX = 2                                 # (c) massimo 2 uscite esenti per per-trade


def riapertura_cme(festivo):
    """la riapertura del Globex dopo la chiusura festiva, in ORA SERVER BCM (UTC+1 fisso, report/OROLOGIO_BCM_2026-09-24.md):
    18:00 ET del giorno festivo (di venerdi: la domenica). Estate USA (EDT, UTC-4) = 23:00 BCM dello STESSO giorno;
    inverno USA (EST, UTC-5) = 00:00 BCM del giorno DOPO."""
    d = festivo + dt.timedelta(days=2) if festivo.weekday() == 4 else festivo
    if inverno_usa(d):
        return dt.datetime.combine(d + dt.timedelta(days=1), dt.time(0, 0))
    return dt.datetime.combine(d, dt.time(23, 0))


def s1_esenzioni(deals, fuori, festivi=None):
    """(esenti, restanti, nota). esenti = [(deal, data festivo, nome, condizione b)]. Una uscita fuori finestra e ESENTE
    solo se: (a) cade nella sessione di riapertura CME dopo un festivo ELENCATO (t >= riapertura e stesso giorno di
    calendario BCM della riapertura); (b) t <= riapertura + 1h30, oppure e la PRIMA uscita del per-trade dopo la
    riapertura; (c) le candidate del per-trade sono al massimo 2 (oltre: nessuna esente)."""
    festivi = FESTIVI_ESENTI if festivi is None else festivi
    cand, resto = [], []
    for d in fuori:
        hit = None
        for fd, nome in festivi.items():
            r0 = riapertura_cme(fd)
            if d['t'] >= r0 and d['t'].date() == r0.date():
                primo = min((q['t'] for q in deals if q['t'] >= r0), default=None)
                if d['t'] <= r0 + S1B_FINESTRA:
                    hit = (d, fd, nome, 'b: entro 1h30 dalla riapertura CME %s' % ds(r0))
                elif d['t'] == primo:
                    hit = (d, fd, nome, 'b: prima uscita del per-trade dopo la riapertura CME %s' % ds(r0))
                break
        if hit:
            cand.append(hit)
        else:
            resto.append(d)
    if len(cand) > S1B_MAX:
        return [], list(fuori), 'c: %d uscite candidate all esenzione > %d: NESSUNA esente' % (len(cand), S1B_MAX)
    return cand, resto, ''


def feriali_da(inizio, n):
    """insieme dei primi n feriali a partire da inizio (compreso)"""
    out, d = set(), inizio
    while len(out) < n:
        if d.weekday() < 5:
            out.add(d)
        d += dt.timedelta(1)
    return out


# ---------------------------------------------------------------- lettura file
def num(s):
    s = ('' if s is None else str(s)).strip()
    if s.lower() == 'true':
        return 1.0
    if s.lower() == 'false':
        return 0.0
    try:
        return float(s.replace(',', '.'))
    except ValueError:
        return float('nan')


def leggi_pertrade(path):
    deals = []
    with open(path, encoding='utf-8', errors='replace', newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            if not (r.get('close_time') or '').strip():
                continue
            deals.append(dict(t=dt.datetime.strptime(r['close_time'].strip(), '%Y.%m.%d %H:%M:%S'),
                              magic=r['magic'].strip(), pid=int(r['position_id']), type=int(r['deal_type']),
                              vol=float(r['volume']), price=float(r['price']), net=float(r['net_profit'])))
    deals.sort(key=lambda d: (d['t'], d['pid']))
    return deals


def chiave(d):
    """la firma strutturale di un deal (close_time, deal_type, price): volume e net NON entrano"""
    return (d['t'], d['type'], round(d['price'], 6))


def posizioni(deals):
    pos = collections.OrderedDict()
    for d in deals:
        pos.setdefault(d['pid'], []).append(d)
    out = []
    for pid, ds in pos.items():
        out.append(dict(pid=pid, deals=ds, t0=ds[0]['t'], t1=ds[-1]['t'], net=sum(x['net'] for x in ds),
                        vol=sum(x['vol'] for x in ds), data=ds[-1]['t'].date()))
    out.sort(key=lambda p: p['t0'])
    return out


def ribasa(pos, deposito=DEPOSITO):
    """metodo A: saldo della corsa prima del primo deal della posizione, r per deal"""
    tutti = sorted((d for p in pos for d in p['deals']), key=lambda d: d['t'])
    acc, i, cum = [], 0, 0.0
    for p in pos:
        while i < len(tutti) and tutti[i]['t'] < p['t0']:
            cum += tutti[i]['net']
            i += 1
        p['B_corsa'] = deposito + cum
        p['r'] = p['net'] / p['B_corsa']
        p['r_deals'] = [d['net'] / p['B_corsa'] for d in p['deals']]
    return pos


def curva(pos, metodo, deposito=DEPOSITO):
    """statistiche a saldo chiuso (curva che riparte da deposito), par. 7 e 9"""
    saldo = picco = deposito
    dd = 0.0
    gior_start, gior_pnl, gior_scarto = collections.OrderedDict(), collections.OrderedDict(), {}
    serie = serie_max = 0
    profit = gain = loss = gain_d = loss_d = 0.0
    vinte = 0
    scarti = []
    for p in pos:
        prima = saldo
        nets = [r * prima for r in p['r_deals']] if metodo == 'A' else [d['net'] for d in p['deals']]
        pnet = sum(nets)
        scarti.append(abs(p['B_corsa'] / prima - 1.0))
        if p['data'] not in gior_start:
            gior_start[p['data']] = prima
            gior_scarto[p['data']] = abs(p['B_corsa'] / prima - 1.0)
        gior_pnl[p['data']] = gior_pnl.get(p['data'], 0.0) + pnet
        for n in nets:
            saldo += n
            picco = max(picco, saldo)
            dd = min(dd, saldo - picco)
            if n > 0:
                gain_d += n
            else:
                loss_d += -n
        profit += pnet
        if pnet > 0:
            gain += pnet
            vinte += 1
        elif pnet < 0:
            loss += -pnet
        if pnet < 0:
            serie += 1
            serie_max = max(serie_max, serie)
        else:
            serie = 0
    pegg_pct, pegg_data = 0.0, None
    for d, pl in gior_pnl.items():
        v = 100.0 * pl / gior_start[d]
        if v < pegg_pct:
            pegg_pct, pegg_data = v, d
    n = len(pos)
    return dict(n=n, deal=sum(len(p['deals']) for p in pos), profit=profit,
                pf_pos=(gain / loss if loss > 0 else float('inf')), pf_deal=(gain_d / loss_d if loss_d > 0 else float('inf')),
                ep=(profit / n if n else 0.0), dd_eur=-dd, dd_pct=-dd / deposito * 100.0,
                pegg_pct=pegg_pct, pegg_data=pegg_data, pegg_scarto=(gior_scarto.get(pegg_data, 0.0) if pegg_data else 0.0),
                serie=serie_max, vinte=vinte, scarto_max=(max(scarti) if scarti else 0.0), saldo_fine=saldo,
                scarti_pos=[(p['data'], sc) for p, sc in zip(pos, scarti)])


def leggi_csv_oos(path):
    if not os.path.exists(path):
        return None
    with open(path, encoding='utf-8', errors='replace', newline='') as fh:
        return [r for r in csv.DictReader(fh) if any((v or '').strip() for v in r.values())]


def leggi_pin_prova(path):
    """pin numerici/bool (||N) del file prova, l'asse (||Y), i pin stringa (senza ||)"""
    pin, asse, stringhe = collections.OrderedDict(), [], []
    with open(path, encoding='utf-8', errors='replace') as fh:
        for ln in fh:
            m = re.match(r'^(Inp[A-Za-z0-9_]+)=([^|]*)\|\|.*\|\|([YN])\s*$', ln)
            if m:
                if m.group(3) == 'N':
                    pin[m.group(1)] = num(m.group(2))
                else:
                    asse.append(m.group(1))
            elif re.match(r'^Inp[A-Za-z0-9_]+=', ln) and '||' not in ln:
                stringhe.append(ln.split('=', 1)[0].strip())
    return pin, asse, stringhe


def p_noedge(tab, n):
    ks = sorted(tab)
    if n <= ks[0]:
        return tab[ks[0]], '>='
    if n >= ks[-1]:
        return tab[ks[-1]], '<='
    for a, b in zip(ks, ks[1:]):
        if a <= n <= b:
            return tab[a] + (tab[b] - tab[a]) * (n - a) / (b - a), '~'


def ds(d):
    """data o datetime nel formato di casa AAAA.MM.GG [HH:MM:SS]"""
    if d is None:
        return '-'
    return d.strftime('%Y.%m.%d %H:%M:%S') if isinstance(d, dt.datetime) else d.strftime('%Y.%m.%d')


def fmt(v):
    return '%+.2f' % v if isinstance(v, float) else str(v)


def pf_txt(v):
    return 'inf' if math.isinf(v) else '%.3f' % v


# ---------------------------------------------------------------- la raccolta
class Raccolta:
    def __init__(self, base):
        self.base = base
        self.file = {}          # etichetta -> dict(oos=rows, is_rows, pt={magic: deals}, nullo=[motivi], note=[])
        self.riepilogo = ''
        self.arch = {}
        self.sha_pin = sha_pin_dalla_riga()

    def path_round(self, f, nome):
        return os.path.join(self.base, 'ROUND_' + f, nome)

    def path_pt(self, magic):
        return os.path.join(self.base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, magic))

    def path_archivio(self, magic):
        p = os.path.join(self.base, 'archivio_R246_pertrade_%d.csv' % magic)
        if os.path.exists(p):
            return p
        return os.path.join(QUI, 'risultati_archivio', 'R246', 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, magic))

    def path_prova(self, f):
        p = self.path_round(f, FILE[f]['prova'])
        if os.path.exists(p):
            return p
        return os.path.join(QUI, 'prove', FILE[f]['prova'])


def pre_lettura_file(rc, f, s1_festivi=False):
    """E0, P0, G1, C0, L0, S1 e il moncone IS per un file. Ritorna il dict del file.
    s1_festivi=True: LETTURA B (S1 emendata dopo i numeri, classe 900), vedi s1_esenzioni."""
    x = FILE[f]
    o = dict(nullo=[], note=[], oos=None, pt={}, is_txt='', p0_n=0, tetto='tetto barre NON LETTO dal REFERTO',
             esenti=[], s1_tot=0, s1_note=[])
    # REFERTO_ROUND: solo la riga del tetto barre (informativa)
    ref = rc.path_round(f, 'REFERTO_ROUND_%s.txt' % f)
    if os.path.exists(ref):
        with open(ref, encoding='utf-8', errors='replace') as fh:
            for ln in fh:
                if ln.startswith('tetto barre'):
                    o['tetto'] = ' '.join(ln.split())
                    break
    # moncone IS
    pis = rc.path_round(f, '%s_%s_IS_%s.csv' % (EA, SIMB, f))
    if not os.path.exists(pis) or os.path.getsize(pis) == 0:
        o['is_txt'] = '_IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta)'
    else:
        rows = leggi_csv_oos(pis) or []
        tr = [num(r.get('Trades')) for r in rows]
        if rows and any(t > 0 for t in tr):
            o['is_txt'] = '_IS con %d righe e Trades %s: il 2024.09.26 HA OPERATO (rc 0). Quel giorno NON e nella curva (par. 7): lo legge il G0' % (len(rows), '/'.join('%g' % t for t in tr))
        else:
            o['is_txt'] = '_IS con %d righe utili, Trades 0 (moncone: ATTESO, non conta)' % len(rows)
    # E0
    rows = leggi_csv_oos(rc.path_round(f, '%s_%s_OOS_%s.csv' % (EA, SIMB, f)))
    if rows is None:
        o['nullo'].append('E0 CSV _OOS ASSENTE')
        return o
    tr = [num(r.get('Trades')) for r in rows]
    if len(rows) != 2 or any(math.isnan(t) or t <= 0 for t in tr):
        o['nullo'].append('E0 _OOS NON BUONO (righe %d, Trades %s; attese 2 con Trades > 0)' % (len(rows), '/'.join(str(r.get('Trades')) for r in rows)))
        return o
    o['oos'] = rows
    # asse InpMagic = gemelle
    mg = sorted(num(r.get('InpMagic')) for r in rows)
    if mg != [float(x['g1']), float(x['g2'])]:
        o['nullo'].append('asse InpMagic DIVERSO [%s] attese %d/%d' % ('/'.join('%g' % v for v in mg), x['g1'], x['g2']))
    # P0
    pp = rc.path_prova(f)
    if not os.path.exists(pp):
        o['nullo'].append('P0 file prova %s ASSENTE (raccolta e repo)' % x['prova'])
    else:
        with open(pp, 'rb') as fh:
            sha = hashlib.sha256(fh.read()).hexdigest().upper()
        hp = rc.sha_pin.get(f)
        dalla_raccolta = os.path.exists(rc.path_round(f, x['prova']))
        if hp is None:
            o['note'].append('SHA256 della prova NON verificato (riga R255 non trovata nel repo)')
        elif sha != hp:
            o['nullo'].append('P0 prova %s SHA256 %s... DIVERSO dal pin %s... (%s)' % (x['prova'], sha[:8], hp[:8], 'raccolta' if dalla_raccolta else 'REPO'))
        else:
            o['note'].append('prova = pin (SHA256 %s..., letta da %s)' % (sha[:8], 'raccolta' if dalla_raccolta else 'REPO: ASSENTE nella raccolta'))
        pin, asse, stringhe = leggi_pin_prova(pp)
        if asse != ['InpMagic']:
            o['nullo'].append('P0 asse del file prova = %s, atteso [InpMagic]' % asse)
        if len(pin) != N_PIN:
            o['nullo'].append('P0 pin del file prova %d, attesi %d' % (len(pin), N_PIN))
        ko = []
        for r in rows:
            for k, v in pin.items():
                o['p0_n'] += 1
                if k not in r:
                    ko.append('%s ASSENTE nel CSV' % k)
                elif math.isnan(v) or abs(num(r[k]) - v) > EPS:
                    ko.append('%s=[%s] atteso %g' % (k, r[k], v))
        if ko:
            o['nullo'].append('P0 pin dal CSV: %d confronti, %d DIVERSI (%s)' % (o['p0_n'], len(ko), '; '.join(ko[:6])))
        o['note'].append('P0 %d confronti numerici/bool su 2 righe (%d pin per riga; pin stringa non confrontati: %s)' % (o['p0_n'], len(pin), ','.join(stringhe) or 'nessuno'))
    # G1 sui campi del CSV
    a, b = rows
    g1 = []
    if num(a['Trades']) != num(b['Trades']):
        g1.append('Trades %s/%s' % (a['Trades'], b['Trades']))
    if not abs(num(a['Profit Factor']) - num(b['Profit Factor'])) <= 0.00005 + EPS:     # |delta| <= 0,00005 come la riga (classe 875)
        g1.append('PF %s/%s' % (a['Profit Factor'], b['Profit Factor']))
    if abs(num(a['Profit']) - num(b['Profit'])) > 0.05 + EPS:
        g1.append('Profit %s/%s' % (a['Profit'], b['Profit']))
    if abs(num(a['Equity DD %']) - num(b['Equity DD %'])) > 0.01 + EPS:
        g1.append('EqDD %s/%s' % (a['Equity DD %'], b['Equity DD %']))
    # C0 / L0 / S1 / G1 per-trade
    per_magic = {}
    for mg in (x['g1'], x['g2']):
        p = rc.path_pt(mg)
        if not os.path.exists(p):
            o['nullo'].append('C0 per-trade %d ASSENTE' % mg)
            continue
        deals = leggi_pertrade(p)
        per_magic[mg] = deals
        riga = [r for r in rows if abs(num(r.get('InpMagic')) - mg) <= EPS]
        if len(riga) == 1:
            if len(deals) != int(num(riga[0]['Trades'])):
                o['nullo'].append('C0 per-trade %d: %d righe contro Trades %s del CSV' % (mg, len(deals), riga[0]['Trades']))
            if abs(sum(d['net'] for d in deals) - num(riga[0]['Profit'])) > 0.05 + EPS:
                o['nullo'].append('C0 per-trade %d: somma net %.2f contro Profit %s del CSV' % (mg, sum(d['net'] for d in deals), riga[0]['Profit']))
        if not deals:
            o['nullo'].append('C0 per-trade %d VUOTO' % mg)
            continue
        if any(d['magic'] != str(mg) for d in deals):
            o['nullo'].append('C0 per-trade %d: colonna magic diversa dal nome del file' % mg)
        if deals[0]['t'].date() < dt.date(2024, 9, 27):
            o['nullo'].append('C0 per-trade %d: prima chiusura %s < 2024.09.27 (non e la gamba continua)' % (mg, ds(deals[0]['t'].date())))
        if deals[-1]['t'].date() > dt.date(2026, 6, 30):
            o['nullo'].append('C0 per-trade %d: ultima chiusura %s > 2026.06.30' % (mg, ds(deals[-1]['t'].date())))
        l0 = [d for d in deals if d['type'] != x['sd']]
        if l0:
            o['nullo'].append('L0 per-trade %d: %d deal con deal_type %d (atteso %d; primo %s)' % (mg, len(l0), l0[0]['type'], x['sd'], ds(l0[0]['t'])))
        s1 = [d for d in deals if not (x['lo'] <= d['t'].strftime('%H:%M:%S') <= x['hi'])]
        o['s1_tot'] += len(s1)
        if s1 and s1_festivi:
            es, s1, nota = s1_esenzioni(deals, s1)
            o['esenti'].extend((mg,) + e for e in es)
            if nota:
                o['s1_note'].append('per-trade %d: %s' % (mg, nota))
            if s1:
                o['nullo'].append('S1 per-trade %d: %d uscite fuori da [%s, %s] NON ESENTI con la S1 emendata%s (prima %s: %s)'
                                  % (mg, len(s1), x['lo'], x['hi'], ' [%s]' % nota if nota else '', ds(s1[0]['t']), ', '.join(ds(d['t']) for d in s1[:6])))
        elif s1:
            o['nullo'].append('S1 per-trade %d: %d uscite fuori da [%s, %s] (prima %s)' % (mg, len(s1), x['lo'], x['hi'], ds(s1[0]['t'])))
    if len(per_magic) == 2:
        d1, d2 = per_magic[x['g1']], per_magic[x['g2']]
        if len(d1) != len(d2):
            g1.append('per-trade %d contro %d righe' % (len(d1), len(d2)))
        else:
            for i, (p, q) in enumerate(zip(d1, d2)):
                if p['t'] != q['t'] or p['pid'] != q['pid'] or p['type'] != q['type'] or abs(p['vol'] - q['vol']) > EPS \
                        or abs(p['price'] - q['price']) > EPS or abs(p['net'] - q['net']) > 0.01 + EPS:
                    g1.append('per-trade riga %d diversa (%s / %s)' % (i + 1, ds(p['t']), ds(q['t'])))
                    break
    if g1:
        o['nullo'].append('G1 DETERMINISMO: ' + '; '.join(g1))
    o['pt'] = per_magic
    return o


def dd_fisso(row):
    p, rf = num(row['Profit']), num(row['Recovery Factor'])
    return abs(p / rf) if rf not in (0.0,) and not math.isnan(rf) else float('nan')


# ---------------------------------------------------------------- G0
def confronto_struttura(mine, arch):
    """righe confrontate nell'ordine: (n confrontate, n diverse, prima differenza)"""
    n = min(len(mine), len(arch))
    diff, prima = 0, ''
    for i in range(n):
        if chiave(mine[i]) != chiave(arch[i]):
            diff += 1
            if not prima:
                prima = 'riga %d: R255 [%s|%d|%.2f] archivio [%s|%d|%.2f]' % (i + 1, ds(mine[i]['t']), mine[i]['type'], mine[i]['price'], ds(arch[i]['t']), arch[i]['type'], arch[i]['price'])
    return n, diff, prima


def struttura_con_eccezione(mine_pos, arch_pos):
    """eccezione del lotto 0,10 (par. 8): un deal di parziale mancante e' ammesso SOLO dove la posizione
    a confronto ha 0,10 lotti e un solo deal, con l'ULTIMO deal identico. Ritorna (n mancanti ammessi, prima anomalia)."""
    if len(mine_pos) != len(arch_pos):
        return None, 'posizioni %d contro %d' % (len(mine_pos), len(arch_pos))
    amm = 0
    for a, b in zip(mine_pos, arch_pos):
        ka, kb = [chiave(d) for d in a['deals']], [chiave(d) for d in b['deals']]
        if ka == kb:
            continue
        # SOLO dove R255w (a) ha 0,10 lotti e un deal (testa par. 8), mai il contrario (classe 875)
        if len(a['deals']) == 1 and abs(a['deals'][0]['vol'] - 0.10) <= EPS and len(b['deals']) == 2 \
                and chiave(a['deals'][0]) == chiave(b['deals'][-1]):
            amm += 1
            continue
        return None, 'posizione del %s: deal %s contro %s' % (ds(a['data']), [ds(k[0]) for k in ka], [ds(k[0]) for k in kb])
    return amm, ''


def g0_long(rc, F):
    o = F.get('R255w')
    if o is None or o['nullo']:
        return dict(liv='NON VERIFICABILE', txt='NON VERIFICABILE (R255w NULLO)', verde=False)
    deals = o['pt'][FILE['R255w']['g1']]
    a1, a2 = rc.arch[794603], rc.arch[794601]
    rIS = [d for d in deals if d['t'].date() <= ERE['IS'][1]]
    rOO = [d for d in deals if d['t'].date() >= ERE['OOS'][0]]
    sIS = sum(d['net'] for d in rIS)
    nC1, nD1, d1 = confronto_struttura(rIS, a1)
    strIS = (len(rIS) == len(a1) and nD1 == 0)
    if len(rIS) == G0_LONG['deal_is'] and abs(sIS - G0_LONG['sum_is']) <= 0.05 + EPS and strIS:
        lv = 'VERDE'
    elif len(rIS) == G0_LONG['deal_is'] and abs(sIS - G0_LONG['sum_is']) <= G0_LONG['tol_giallo'] + EPS:
        lv = 'GIALLO'
    else:
        lv = 'ROSSO'
    nC2, nD2, d2 = confronto_struttura(rOO, a2)
    if len(rOO) == len(a2) and nD2 == 0:
        lvO, ecc = 'VERDE-STRUTTURA', ''
    else:
        amm, anom = struttura_con_eccezione(posizioni(rOO), posizioni(a2))
        if amm is not None:
            lvO, ecc = 'VERDE-STRUTTURA', ' con eccezione del lotto 0,10 (%d deal di parziale mancanti, ultimo deal identico)' % amm
        else:
            lvO, ecc = 'ROSSO', ' (%s)' % anom
    txt = ('era IS (<= 2025.06.09): %d deal, %d posizioni, somma %.2f contro r6 %d deal / %.2f; struttura contro 794603: %d contro %d righe, confrontate %d, DIVERSE %d%s -> %s'
           % (len(rIS), len(posizioni(rIS)), sIS, G0_LONG['deal_is'], G0_LONG['sum_is'], len(rIS), len(a1), nC1, nD1, (' (prima: %s)' % d1 if d1 else ''), lv)
           + ' | era OOS (>= 2025.06.10) contro 794601: %d deal (%d posizioni) contro %d (%d), confrontate %d, DIVERSE %d%s -> %s%s'
           % (len(rOO), len(posizioni(rOO)), len(a2), len(posizioni(a2)), nC2, nD2, (' (prima: %s)' % d2 if d2 else ''), lvO, ecc))
    return dict(liv=lv, livO=lvO, txt=txt, verde=(lv == 'VERDE' and lvO == 'VERDE-STRUTTURA'), rosso=(lv == 'ROSSO' or lvO == 'ROSSO'))


def g0_ancora(F):
    o = F.get('R255a')
    if o is None or o['nullo']:
        return 'NON VERIFICABILE (R255a NULLO)', False
    deals = o['pt'][FILE['R255a']['g1']]
    out = []
    ok = True
    for era, att in (('IS', G0_ANCORA['deal_is']), ('OOS', G0_ANCORA['deal_oos'])):
        rr = [d for d in deals if era_di(d['t'].date()) == era]
        pos = posizioni(rr)
        e010 = sum(1 for p in pos if len(p['deals']) == 1 and abs(p['vol'] - 0.10) <= EPS)
        manc = att - len(rr)
        if manc == 0:
            lv = 'VERDE-STRUTTURA'
        elif 0 < manc <= e010:
            lv = 'VERDE-STRUTTURA con eccezione del lotto 0,10 (%d deal di parziale mancanti)' % manc
        else:
            lv, ok = 'ROSSO', False
        out.append('era %s: %d deal (%d posizioni, a 0,10 con un solo deal %d) contro R54a %d -> %s' % (era, len(rr), len(pos), e010, att, lv))
    prima = ds(deals[0]['t']) if deals else 'nessuna'
    return ' | '.join(out) + ' | prima riga %s (Profit e DD NON si confrontano: R54a girava a 100000)' % prima + ('' if ok else ' -> ROSSO: lo short su questo binario NON e R54a; il round si legge al suo interno, ma "l ancora = R54a" cade'), ok


def g0_sottoinsieme(F):
    """ancora e stXX dentro il NUDO dello stesso orologio: per posizione, con l'eccezione del lotto 0,10"""
    out, rosso = [], set()
    for cf in ['ancora'] + ST_ORDINE:
        for k in (0, 1):
            tf, tn = CONF[cf][k], CONF['nudo'][k]
            if F[tf]['nullo'] or F[tn]['nullo']:
                out.append('%s in %s: NON VERIFICABILE (un file della coppia e NULLO, classe 781)' % (tf, tn))
                continue
            pf = posizioni(F[tf]['pt'][FILE[tf]['g1']])
            pn = posizioni(F[tn]['pt'][FILE[tn]['g1']])
            nudo_per_giorno = {p['data']: p for p in pn}
            senza, ecc, primo = 0, 0, ''
            for p in pf:
                q = nudo_per_giorno.get(p['data'])
                if q is None:
                    senza += 1
                    primo = primo or ds(p['t1'])
                    continue
                kf, kn = [chiave(d) for d in p['deals']], [chiave(d) for d in q['deals']]
                if kf == kn:
                    continue
                corto, lungo = (p, q) if len(kf) < len(kn) else (q, p)
                if len(corto['deals']) == 1 and abs(corto['deals'][0]['vol'] - 0.10) <= EPS and len(lungo['deals']) == 2 \
                        and chiave(corto['deals'][0]) == chiave(lungo['deals'][-1]):
                    ecc += 1
                else:
                    senza += 1
                    primo = primo or ds(p['t1'])
            esito = 'VERDE-SOTTOINSIEME' + (' (eccezione del lotto 0,10 su %d posizioni)' % ecc if ecc else '') if senza == 0 else 'ROSSO -> NON LEGGIBILE finche non si trova il perche'
            if senza:
                rosso.add(cf)
            out.append('%s in %s: %d pos. (%d deal) contro nudo %d pos. (%d deal), senza gemello %d%s -> %s'
                       % (tf, tn, len(pf), sum(len(p['deals']) for p in pf), len(pn), sum(len(p['deals']) for p in pn), senza, (' (primo %s)' % primo if primo else ''), esito))
    return out, rosso


def g0_ingressi(F):
    out, rosso = [], set()
    for cf in USCITE:
        for k in (0, 1):
            tu, ta = CONF[cf][k], CONF['ancora'][k]
            if F[tu]['nullo'] or F[ta]['nullo']:
                out.append('%s contro %s: NON VERIFICABILE (un file della coppia e NULLO, classe 781)' % (tu, ta))
                continue
            pu = posizioni(F[tu]['pt'][FILE[tu]['g1']])
            pa = posizioni(F[ta]['pt'][FILE[ta]['g1']])
            gu, ga = {p['data'] for p in pu}, {p['data'] for p in pa}
            dif = len(gu ^ ga)
            ok = (dif == 0 and len(pu) == len(pa))
            if not ok:
                rosso.add(cf)
            out.append('%s contro %s: giornate con posizione %d contro %d (non in comune %d), posizioni %d contro %d -> %s'
                       % (tu, ta, len(gu), len(ga), dif, len(pu), len(pa), 'ok (stessi ingressi)' if ok else 'DIVERSO = la manopola tocca gli ingressi: NON LEGGIBILE (par. 5 smentito)'))
    return out, rosso


def riga_g1(F, f):
    """la riga del CSV _OOS della gemella g1"""
    for r in F[f]['oos'] or []:
        if abs(num(r.get('InpMagic')) - FILE[f]['g1']) <= EPS:
            return r
    return None


def g2_manopole(F):
    out, non_eseguite = [], set()

    def tr(f):
        r = riga_g1(F, f)
        return num(r['Trades']) if r else float('nan')

    def pr(f):
        r = riga_g1(F, f)
        return num(r['Profit']) if r else float('nan')

    def ok(f):
        return not F[f]['nullo']

    def meno(lbl, cf, fa, fb):
        if ok(fa) and ok(fb):
            a, b = tr(fa), tr(fb)
            morde = (a < b)
            if not morde:
                non_eseguite.add(cf)
            out.append('%s: Trades %s %g contro %s %g -> %s' % (lbl, fa, a, fb, b, 'MORDE' if morde else 'NON ESEGUITA (uguali o di piu)'))
        else:
            out.append('%s: NON VERIFICABILE (un file e NULLO)' % lbl)
    for k, oro in ((0, '14:30'), (1, '15:30')):
        fA, fN = CONF['ancora'][k], CONF['nudo'][k]
        meno('EMA ' + oro, 'ancora', fA, fN)
        for cf in ST_ORDINE:
            meno('Supertrend %s %s' % (cf, oro), cf, CONF[cf][k], fN)
        meno('parz0 ' + oro, 'parz0', CONF['parz0'][k], fA)
        fG, fI = CONF['tp05'][k], CONF['tp15'][k]
        if ok(fG) and ok(fA) and ok(fI):
            g, a, i = tr(fG), tr(fA), tr(fI)
            pg, pa, pi = pr(fG), pr(fA), pr(fI)
            ordine = (g >= a >= i and g > i)
            divers = not (abs(pg - pa) <= 0.005 and abs(pa - pi) <= 0.005)
            if not (ordine and divers):
                non_eseguite.update(('tp05', 'tp15'))
            out.append('TP1_R %s: Trades tp05 %g >= ancora %g >= tp15 %g con tp05 > tp15 -> %s; Profit %.2f / %.2f / %.2f -> %s'
                       % (oro, g, a, i, 'ordine ok' if ordine else 'ROVESCIATO O UGUALE = NON ESEGUITA', pg, pa, pi, 'non identici = ok' if divers else 'IDENTICI = NON ESEGUITA'))
        else:
            out.append('TP1_R %s: NON VERIFICABILE (un file e NULLO)' % oro)
        fK = CONF['trail0'][k]
        if ok(fK) and ok(fA):
            morde = abs(pr(fK) - pr(fA)) > 0.005
            if not morde:
                non_eseguite.add('trail0')
            out.append('trail0 %s: Profit trail0 %.2f contro ancora %.2f -> %s' % (oro, pr(fK), pr(fA), 'MORDE' if morde else 'IDENTICO = NON ESEGUITA'))
        else:
            out.append('trail0 %s: NON VERIFICABILE (un file e NULLO)' % oro)
    # orologio
    oro_out = []
    for cf, (f4, f5) in CONF.items():
        if not (ok(f4) and ok(f5)):
            oro_out.append('%s/%s: NON VERIFICABILE (un file della coppia e NULLO, classe 781)' % (f4, f5))
            continue
        d4 = F[f4]['pt'][FILE[f4]['g1']]
        d5 = F[f5]['pt'][FILE[f5]['g1']]
        w4 = [chiave(d) for d in d4 if inverno_usa(d['t'].date())]
        w5 = [chiave(d) for d in d5 if inverno_usa(d['t'].date())]
        e4 = sum(1 for d in d4 if not inverno_usa(d['t'].date()))
        e5 = sum(1 for d in d5 if not inverno_usa(d['t'].date()))
        same = (w4 == w5)
        if same and cf != 'long':
            non_eseguite.add(cf)
        oro_out.append('%s/%s (%s): inverno USA 14:30 %d deal, 15:30 %d deal, righe d inverno %s; estate 14:30 %d deal, 15:30 %d deal (un ora DOPO la cash: descrizione)'
                       % (f4, f5, cf, len(w4), len(w5), 'IDENTICHE = NON ESEGUITA (la manopola non morde)' if same else 'DIVERSE = ok', e4, e5))
    return out, oro_out, non_eseguite


# ---------------------------------------------------------------- curve
def curve_configurazione(F, cf):
    """tre curve per era dai per-trade g1 dei due file (gia' ribasati sulla propria corsa)"""
    f4, f5 = CONF[cf]
    p4 = ribasa(posizioni(F[f4]['pt'][FILE[f4]['g1']])) if not F[f4]['nullo'] else None
    p5 = ribasa(posizioni(F[f5]['pt'][FILE[f5]['g1']])) if not F[f5]['nullo'] else None
    out = collections.OrderedDict()

    def sel(nome):
        if p4 is None or (nome != 'CONTROLLO' and p5 is None):
            return None
        if nome == 'CONTROLLO':
            pos = list(p4)
        elif nome == 'IN FASE':
            pos = [p for p in p4 if not inverno_usa(p['data'])] + [p for p in p5 if inverno_usa(p['data'])]
        else:   # FTMO-DOC: UE solare -> file 15:30 (comprende l'inverno USA e i 40 feriali di disallineamento)
            pos = [p for p in p4 if not inverno_ue(p['data'])] + [p for p in p5 if inverno_ue(p['data'])]
        pos.sort(key=lambda p: p['t0'])
        return pos
    for nome in ('IN FASE', 'CONTROLLO', 'FTMO-DOC'):
        pos = sel(nome)
        if pos is None:
            out[nome] = None
            continue
        c = collections.OrderedDict()
        # classe 876: la corsa e' UNA (moncone + 641 giorni) e la curva per era riparte da 10000, quindi nell'era OOS
        # lo scarto della LETTERA (par. 7) contiene anche l'utile dell'era IS della corsa. Si calcola ACCANTO lo scarto
        # con la curva continua (un solo 10000 all'inizio): e' quello che misura il solo errore di lotto. La regola
        # d'ufficio resta sulla lettera; il numero continuo e' stampato perche' chi legge veda la causa.
        cont = {m: curva(pos, m) for m in ('A', 'B')}
        for era in ERE:
            pe = [p for p in pos if era_di(p['data']) == era]
            sc_cont = max([sc for m in cont for d, sc in cont[m]['scarti_pos'] if era_di(d) == era] or [0.0])
            c[era] = dict(A=curva(pe, 'A'), B=curva(pe, 'B'), pos=pe, scarto_cont=sc_cont,
                          estate=sum(1 for p in pe if not inverno_usa(p['data'])), inverno=sum(1 for p in pe if inverno_usa(p['data'])),
                          confine=[(p['data'], p['net']) for p in pe if p['data'] in CONFINE_14 | CONFINE_15],
                          fuori_era=0)
        c['scartati'] = len(pos)
        out[nome] = c
    out['p4'], out['p5'] = p4, p5
    return out


def leggi_r1r2(dd_a, dd_b, S, e_eff, scarto, scarto_cont=None):
    lo, hi = min(dd_a, dd_b), max(dd_a, dd_b)
    if lo * (1 - e_eff) > S + EPS:
        v = 'VIOLATO'
    elif hi * (1 + e_eff) <= S + EPS:
        v = 'RISPETTATO'
    else:
        v = 'NON RISOLTO'
    if scarto > 0.10 and any(0.8 * S <= d <= 1.2 * S for d in (lo, hi)):     # R252a par. 5 / testa par. 7: anche un VIOLATO (classe 875)
        v = 'NON RISOLTO (d ufficio: scarto di saldo %.1f%% > 10%% e DD fra 0,8 e 1,2 volte la soglia)' % (scarto * 100)
        if scarto_cont is not None and scarto_cont <= 0.10:
            v += ' [classe 876: a curva CONTINUA lo scarto e %.1f%% <= 10%%: l eccesso e l utile dell era precedente della corsa, non il lotto; la lettera del par. 7 resta, la causa e dichiarata]' % (scarto_cont * 100)
    return v


def leggi_r3(c_is, c_oos, pegg_csv_ok):
    """(verdetto, testo). c_* = dict con A e B. pegg_csv_ok = i due CSV _OOS hanno Peggior Giornata % >= -1,10"""
    viol_b, viol_a = [], []
    for era, c in (('IS', c_is), ('OOS', c_oos)):
        if c['B']['pegg_pct'] < R3_MIN - EPS:
            viol_b.append('%s B %.3f%% il %s (scarto di saldo corsa/curva quel giorno %.1f%%)' % (era, c['B']['pegg_pct'], ds(c['B']['pegg_data']), c['B']['pegg_scarto'] * 100))
        if c['A']['pegg_pct'] < R3_MIN - EPS:
            viol_a.append('%s A %.3f%% il %s' % (era, c['A']['pegg_pct'], ds(c['A']['pegg_data'])))
    if viol_a and pegg_csv_ok:
        viol_a[-1] += ' [CONTRADDIZIONE: il CSV _OOS dice >= -1,10, la curva A no: si legge la giornata]'
    if viol_a or viol_b:
        cl = ' (classe 833: A rispetta, B viola)' if (viol_b and not viol_a) else ''
        return 'VIOLATO', 'VIOLATO%s: %s' % (cl, '; '.join(viol_a + viol_b))
    txt = 'A %.3f%% / %.3f%%, B %.3f%% / %.3f%% (IS / OOS)' % (c_is['A']['pegg_pct'], c_oos['A']['pegg_pct'], c_is['B']['pegg_pct'], c_oos['B']['pegg_pct'])
    if pegg_csv_ok:
        txt += '; condizione sufficiente del CSV (metodo A) soddisfatta, B calcolato e >= -1,10'
    return 'RISPETTATO', txt


def e_eff_long(rc, F, g0l):
    if g0l.get('rosso') or not g0l.get('verde', False) and g0l['liv'] == 'NON VERIFICABILE':
        return E_MIN, None, None, 'G0-LONG %s: e_IS/e_OOS illeggibili, e_eff = %.4f (banda p99, par. 7)' % (g0l['liv'], E_MIN)
    pw = ribasa(posizioni(F['R255w']['pt'][FILE['R255w']['g1']]))
    es = {}
    for era, mg in (('IS', 794603), ('OOS', 794601)):
        pa = ribasa(posizioni(rc.arch[mg]), 100000.0)
        dd_w = curva([p for p in pw if era_di(p['data']) == era], 'A')['dd_pct']
        dd_a = curva(pa, 'A')['dd_pct']
        es[era] = (abs(dd_w - dd_a) / dd_a if dd_a > 0 else float('nan'), dd_w, dd_a)
    e = max(es['IS'][0], es['OOS'][0], E_MIN)
    txt = 'e_IS = |%.4f - %.4f| / %.4f = %.4f (R255w era IS contro 794603, DD metodo A %%); e_OOS = |%.4f - %.4f| / %.4f = %.4f (contro 794601); e_eff = max(e_IS, e_OOS, %.4f) = %.4f' \
        % (es['IS'][1], es['IS'][2], es['IS'][2], es['IS'][0], es['OOS'][1], es['OOS'][2], es['OOS'][2], es['OOS'][0], E_MIN, e)
    return e, es['IS'][0], es['OOS'][0], txt


def m4_altopiano(ris):
    """M4 (testa par. 10) e le parole finali PROMOSSA / NON PROMOSSA, scritte DOPO M4 (classe 874)"""
    out = []
    stato = []
    for cf in ST_ORDINE:
        r = ris.get(cf, {})
        stato.append(bool(r.get('passa_r')) and bool(r.get('passa_m')))
    out.append('   Supertrend %s: celle che passano R1-R3 E M1-M3 (con n >= 150): %s' % ('/'.join(ST_ORDINE), ' '.join('%s=%s' % (c, 'si' if s else 'no') for c, s in zip(ST_ORDINE, stato))))
    best, cur = [], []
    for c, s in zip(ST_ORDINE, stato):
        cur = cur + [c] if s else []
        if len(cur) > len(best):
            best = list(cur)
    centro = None
    if len(best) >= 3:
        centro = best[len(best) // 2] if len(best) % 2 == 1 else min(best[len(best) // 2 - 1:len(best) // 2 + 1], key=lambda c: abs(ST_ORDINE.index(c) - ST_ORDINE.index('stH8')))
        out.append('   -> altopiano di %d celle contigue (%s): si porta avanti la CENTRALE %s%s' % (len(best), ','.join(best), centro, ' (tratto pari: la piu vicina a H8)' if len(best) % 2 == 0 else ''))
    else:
        out.append('   -> NON C E UNA CONFIGURAZIONE ROBUSTA fra i Supertrend (tratto contiguo piu lungo: %d)%s' % (len(best), ' [merito sospeso ovunque: M4 non valutabile]' if not any(r.get('passa_m') for r in ris.values() if r) else ''))
    tp = {cf: bool(ris.get(cf, {}).get('passa_r')) and bool(ris.get(cf, {}).get('passa_m')) for cf in ('tp05', 'ancora', 'tp15')}
    if tp['ancora']:
        out.append('   TP1_R (0,5 / 1,0 / 1,5): 1,0 (ancora) passa -> puo essere un centro%s' % ('' if tp['tp05'] or tp['tp15'] else ' (bordi no: centro isolato, si dichiara)'))
    elif tp['tp05'] or tp['tp15']:
        out.append('   TP1_R: vince un BORDO (%s) -> DIREZIONE INDICATA, NON UNA CONFIGURAZIONE' % ', '.join(k for k, v in tp.items() if v))
    else:
        out.append('   TP1_R: nessuna cella passa rischio e merito -> nessun centro')
    out.append('   EMA, parziale, trailing, orologio: interruttori, nessun altopiano (li sostituisce M3 piu il passo dopo)')
    # classe 874: la parola PROMOSSA si scrive DOPO M4, mai "salvo M4" sulla cella
    for cf, r in ris.items():
        e = r.get('esito') or ''
        if not e.startswith('PASSA RISCHIO E MERITO'):
            continue
        coda = e[len('PASSA RISCHIO E MERITO'):].replace(': M4 decide nella sez. 5', '')
        if cf in ST_ORDINE:
            if cf == centro:
                r['esito'] = 'PROMOSSA AL PASSO DOPO (centro dell altopiano M4 %s)%s' % (','.join(best), coda)
            elif centro is not None and cf in best:
                r['esito'] = 'NON PROMOSSA: passa rischio e merito, ma nell altopiano M4 NON e la centrale (%s)%s' % (centro, coda)
            else:
                r['esito'] = 'NON PROMOSSA: passa rischio e merito, ma M4: NON C E UNA CONFIGURAZIONE ROBUSTA (cella che sporge)%s' % coda
        elif cf in ('tp05', 'tp15'):
            r['esito'] = 'NON PROMOSSA: M4, vince un BORDO del TP1_R -> DIREZIONE INDICATA, NON UNA CONFIGURAZIONE%s' % coda
        else:
            r['esito'] = 'PROMOSSA AL PASSO DOPO (interruttore: nessun altopiano, par. 10)%s' % coda
    return out


# ---------------------------------------------------------------- LETTURA B: testa, esenzioni per nome, peso nelle curve
def testa_lettura_b():
    return [
        'LETTURA B -- S1 EMENDATA DOPO I NUMERI, IN ATTESA DELLA FIRMA DI CLAUDIO',
        '  CLASSE 900: criterio cambiato A NUMERO VISTO. La S1 della testa (par. 8, congelata prima dei numeri) ha annullato 19 file su 24,',
        '  ognuno per UNA uscita (due nel trail0 14:30) alla riapertura CME dopo un festivo USA. Questa lettura applica una S1 emendata',
        '  scritta DOPO aver visto quei numeri: e uno strumento tarato sul caso, NON una prova indipendente. La lettura valida senza firma',
        '  resta la A (stesso lettore senza --s1-festivi: report/LETTURA_R255_2026-09-28.md, 19 file NULLI).',
        '  EMENDAMENTO: una uscita fuori finestra e ESENTE solo se TUTTE: (a) cade nella sessione di riapertura CME dopo una chiusura festiva',
        '  USA ELENCATA PER NOME (t >= riapertura e stesso giorno di calendario BCM della riapertura; riapertura = 18:00 ET del festivo,',
        '  di venerdi la domenica = 23:00 BCM stesso giorno in estate USA, 00:00 BCM del giorno dopo in inverno USA; BCM = UTC+1 fisso);',
        '  (b) entro 1h30 dalla riapertura, oppure prima uscita del per-trade dopo la riapertura; (c) al massimo %d esenti per per-trade' % S1B_MAX,
        '  (oltre: nessuna). Tutto il resto resta NULLO come in A. Il NULLO della riga si toglie solo se il suo UNICO motivo e S1, col',
        '  conteggio uguale a quello del lettore e tutte le uscite esentate.',
        '  DEVIAZIONE DICHIARATA dalla stesura del 28/09: la condizione (a) era "giorno di calendario SUCCESSIVO al festivo". Misurato: in',
        '  estate USA la riapertura (18:00 ET) cade alle 23:00 BCM DELLO STESSO GIORNO (Juneteenth 2025.06.19 23:05, Memorial Day 2026.05.25',
        '  23:05): alla lettera quelle due NON sarebbero esenti. La (a) qui e la sessione di riapertura, piu STRETTA di "23:00-01:30 di un',
        '  giorno qualunque": ogni esenzione sotto riporta anche se soddisfa la stesura letterale.',
        '']


def sezione_esenzioni(rc, F, riga_s1_tolte):
    L = ['', '1-bis. S1 EMENDATA (LETTURA B): ESENZIONI PER NOME (file, magic, data, ora, festivo, condizione, P/L della posizione)']
    n = 0
    visti = collections.Counter()
    for f in FILE:
        o = F[f]
        for mg, d, fd, nome, cond in o['esenti']:
            n += 1
            visti[fd] += 1
            pos = [q for q in o['pt'].get(mg, []) if q['pid'] == d['pid']]
            lett_a = (d['t'].date() == fd + dt.timedelta(days=1))
            hh = d['t'].strftime('%H:%M:%S')
            lett_b = (hh >= '23:00:00' or hh <= '01:30:00')
            L.append('  ESENTE %s %-6s %s magic %d: uscita %s dopo %s %s (%s); posizione %d: %d deal, P/L %+.2f; stesura letterale: (a) giorno successivo %s, 23:00-01:30 %s'
                     % (f, FILE[f]['cf'], FILE[f]['ora'], mg, ds(d['t']), ds(fd), nome, cond, d['pid'], len(pos), sum(q['net'] for q in pos),
                        'SI' if lett_a else 'NO', 'SI' if lett_b else 'NO'))
        for t in o['s1_note']:
            L.append('  NOTA %s: %s' % (f, t))
    if not n:
        L.append('  nessuna esenzione')
    rimasti = [f for f in FILE if any(s.startswith('S1 ') for s in F[f]['nullo'])]
    L.append('  uscite esentate: %d; file che restano NULLI per S1 anche con l emendamento: %s' % (n, ', '.join(rimasti) if rimasti else 'nessuno'))
    for f in rimasti:
        L.append('    %s: %s' % (f, ' | '.join(s for s in F[f]['nullo'] if s.startswith('S1 '))))
    L.append('  NULLI DELLA RIGA TOLTI (unico motivo S1, conteggio uguale, tutte esentate): %s' % (', '.join(riga_s1_tolte) if riga_s1_tolte else 'nessuno'))
    for fd, nome in FESTIVI_ESENTI.items():
        L.append('  festivo in elenco %s %s: riapertura CME %s BCM -> %s' % (ds(fd), nome, ds(riapertura_cme(fd)), ('osservato: %d uscite esentate' % visti[fd]) if visti[fd] else 'NON osservato in questa raccolta'))
    # i previsti: controllati su TUTTE le uscite fuori finestra dei 48 per-trade, ma non esentano
    for fd, nome in FESTIVI_PREVISTI.items():
        r0 = riapertura_cme(fd)
        oss = []
        for f in FILE:
            x = FILE[f]
            for mg, deals in F[f]['pt'].items():
                oss += ['%s/%d %s' % (f, mg, ds(d['t'])) for d in deals
                        if not (x['lo'] <= d['t'].strftime('%H:%M:%S') <= x['hi']) and d['t'] >= r0 and d['t'].date() == r0.date()]
        L.append('  festivo previsto %s %s (riapertura CME %s BCM): %s' % (ds(fd), nome, ds(r0), ('OSSERVATO ma NON in elenco -> resta NULLO, va aggiunto per nome con la firma: ' + ', '.join(oss[:6])) if oss else 'previsto, non osservato'))
    L.append('  CONTRO-ESEMPIO DELLA B: "pin dell ora non arrivato" (corsa a ora 14 nel file 15:30) sposta TUTTE le uscite di un ora: finirebbero prima di lo')
    L.append('  in giorni feriali qualunque e nessuna sarebbe esente -> NULLO anche qui (autotest). Lo misura anche G2 L OROLOGIO sotto: righe d inverno')
    L.append('  15:30 IDENTICHE a quelle 14:30 = l ora 15 non e arrivata. Il peso delle esenzioni nelle curve e stampato per configurazione (riga S1-B).')
    return L


def esenti_nelle_curve(F, cf, cv):
    """quante posizioni ESENTATE entrano in ogni curva (g1: la curva si fa dalla gemella g1) e con che P/L"""
    f4, f5 = CONF[cf]
    es = {f: {d['pid'] for mg, d, fd, nome, cond in F[f]['esenti'] if mg == FILE[f]['g1']} for f in (f4, f5)}
    parti, conta = [], {}
    for nome in ('IN FASE', 'CONTROLLO', 'FTMO-DOC'):
        c = cv.get(nome)
        if c is None:
            parti.append('%s n.d.' % nome)
            continue
        dentro = []
        for era in ERE:
            for p in c[era]['pos']:
                src = f4 if any(p is q for q in (cv['p4'] or [])) else f5
                if p['pid'] in es[src]:
                    dentro.append((src, era, p))
        parti.append('%s %d (%s)' % (nome, len(dentro), ', '.join('%s era %s %s P/L %+.2f' % (s_, e_, ds(p['data']), p['net']) for s_, e_, p in dentro) or 'nessuna'))
        conta[nome] = len(dentro)
    return ('S1-B posizioni ESENTATE dentro le curve (gemella g1): ' + '; '.join(parti) + (' [esentate nei file: %s]' % ', '.join('%s %d' % (f, len(es[f])) for f in (f4, f5))), conta)


def composizione_in_fase(cf, cv):
    """da dove viene la curva IN FASE: per file e per era, la parte PRESA (14:30 d estate USA, 15:30 d inverno USA) e la
    parte LASCIATA FUORI (14:30 d inverno = un ora prima della cash, 15:30 d estate = un ora dopo), in denaro (metodo B)"""
    f4, f5 = CONF[cf]
    out = []
    for f, pp, presa_inv in ((f4, cv['p4'], False), (f5, cv['p5'], True)):
        if pp is None:
            continue
        pezzi = []
        for era in ERE:
            pe = [p for p in pp if era_di(p['data']) == era]
            dentro = [p for p in pe if inverno_usa(p['data']) == presa_inv]
            fuori = [p for p in pe if inverno_usa(p['data']) != presa_inv]
            for lbl, q in (('PRESA', dentro), ('fuori', fuori)):
                g = sum(p['net'] for p in q if p['net'] > 0)
                l_ = -sum(p['net'] for p in q if p['net'] < 0)
                pezzi.append('%s %s n %d P/L %+.2f PF %s' % (era, lbl, len(q), g - l_, pf_txt(g / l_) if l_ > 0 else ('inf' if g > 0 else '-')))
        out.append('  S1-B COMPOSIZIONE IN FASE, %s %s (%s USA PRESO nella curva che decide, l altra stagione fuori): %s'
                   % (f, FILE[f]['ora'], 'INVERNO' if presa_inv else 'ESTATE', ' | '.join(pezzi)))
    return out


# ---------------------------------------------------------------- il referto
def riga_curva(lbl, c):
    return ('  %-8s %3d pos (%3d deal) Profit %9.2f  PF pos %s / deal %s  EP %+7.2f  vinte %d  DD chiuso %7.2f EUR = %6.3f%%  pegg. giorno %+.3f%% (%s)  serie %d  scarto saldo max %.2f%%'
            % (lbl, c['n'], c['deal'], c['profit'], pf_txt(c['pf_pos']), pf_txt(c['pf_deal']), c['ep'], c['vinte'], c['dd_eur'], c['dd_pct'], c['pegg_pct'], ds(c['pegg_data']), c['serie'], c['scarto_max'] * 100))


def referto(base, s1_festivi=False):
    base, nota_base = trova_raccolta(base)
    rc = Raccolta(base)
    L = []
    if s1_festivi:
        L.extend(testa_lettura_b())
    L.append('LETTURA R255 -- IL LATO SHORT DELL APERTURA DOW A DUE OROLOGI (criteri: prove/R255a_short_DOW_ancora_1430.txt par. 7-17, congelati prima dei numeri)')
    L.append('raccolta: %s' % base)
    if nota_base:
        L.append('  ' + nota_base)
    n_dir = sum(1 for f in FILE if os.path.isdir(rc.path_round(f, '')))
    L.append('cartelle ROUND_R255a..x trovate: %d su 24%s; SHA256 del pin per i file prova: %s' % (
        n_dir, '' if n_dir == 24 else ' (le mancanti escono NULLE per E0: e un file mancante, non un file cattivo)',
        '%d letti dalla riga' % len(rc.sha_pin) if len(rc.sha_pin) == 24 else 'NON LETTI (%d su 24)' % len(rc.sha_pin)))
    prip = os.path.join(base, 'RIEPILOGO_R255.txt')
    riep = {}
    if os.path.exists(prip):
        with open(prip, encoding='utf-8', errors='replace') as fh:
            rc.riepilogo = fh.read()
        for ln in rc.riepilogo.splitlines():
            for k in ('FILE NULLI', 'G0-LONG', 'G0-ANCORA', 'G0-SOTTOINSIEME', 'G0-INGRESSI', 'G2 LE MANOPOLE', 'G2 L OROLOGIO', 'CLASSE 166', 'CARTELLE ATTESE', 'PERTRADE (', 'ROUND PARTITI', 'TETTO BARRE'):
                if ln.startswith(k):
                    riep[k] = ln.strip()
        L.append('RIEPILOGO_R255.txt letto: %d righe; le sue pre-letture si RILEGGONO qui sotto dai per-trade (la riga non e il verdetto)' % len(rc.riepilogo.splitlines()))
        for k in ('CARTELLE ATTESE', 'PERTRADE (', 'ROUND PARTITI', 'CLASSE 166', 'TETTO BARRE'):
            if k in riep:
                L.append('  [riga] ' + riep[k][:400])
    else:
        L.append('RIEPILOGO_R255.txt ASSENTE: si legge tutto dai file (classe 166 e rc NON verificabili da qui)')
    for mg in (794603, 794601):
        p = rc.path_archivio(mg)
        if not os.path.exists(p):
            L.append('ARCHIVIO %d ASSENTE (raccolta e repo): G0-LONG e e_eff non leggibili' % mg)
            rc.arch[mg] = []
        else:
            rc.arch[mg] = leggi_pertrade(p)
            L.append('archivio R246 per-trade %d: %d righe, %d posizioni, somma %.2f, chiusure %s -> %s (deposito 100000)'
                     % (mg, len(rc.arch[mg]), len(posizioni(rc.arch[mg])), sum(d['net'] for d in rc.arch[mg]), ds(rc.arch[mg][0]['t'].date()) if rc.arch[mg] else '-', ds(rc.arch[mg][-1]['t'].date()) if rc.arch[mg] else '-'))
    L.append('')
    L.append('1. PRE-LETTURA PER FILE (E0, P0, G1, C0, L0, S1; moncone IS; classe 772: un file KO = NULLO, la sua configurazione = NULLA)')
    F = collections.OrderedDict()
    for f in FILE:
        F[f] = pre_lettura_file(rc, f, s1_festivi)
        o = F[f]
        st_ = 'NULLO: ' + ' | '.join(o['nullo']) if o['nullo'] else 'ok'
        r = riga_g1(F, f)
        oos = ('Trades %s Profit %s PF %s EqDD %s%% Pegg %s%% DD_fisso %.2f' % (r['Trades'], r['Profit'], r['Profit Factor'], r['Equity DD %'], r['Peggior Giornata %'], dd_fisso(r))) if r else 'CSV _OOS non leggibile'
        L.append('  %s %-6s %-5s %s | %s | %s | %s | %s' % (f, FILE[f]['cf'], FILE[f]['ora'], st_, oos, o['is_txt'], '; '.join(o['note']), o['tetto']))
    # classe 873: i NULLI della riga (classe 166 motore diverso dal pin, SHA della prova, rc 1, freschezza) si
    # UNISCONO a quelli ricalcolati: il lettore non vede il motore compilato, la riga si'
    nr = nulli_della_riga(rc.riepilogo)
    solo_qui = []
    if not rc.riepilogo:
        L.append('  ATTENZIONE: RIEPILOGO assente -> classe 166 (motore = pin), rc e freschezza dei file NON VERIFICATI: ogni esito sotto vale SOLO se il motore e quello del pin')
    elif len(nr) != 24:
        L.append('  ATTENZIONE: nel RIEPILOGO %d righe di ESITO su 24 (mancano: %s): per quei file classe 166 e rc NON VERIFICATI' % (len(nr), ', '.join(f for f in FILE if f not in nr)))
    riga_s1_tolte = collections.OrderedDict()
    for f in FILE:
        if nr.get(f) and s1_festivi:
            # LETTURA B: il NULLO della riga si toglie SOLO se il suo unico motivo e S1 (S1 e l ultimo motivo della riga:
            # se la stringa comincia con S1 non ce ne sono altri), il conteggio della riga = quello del lettore (g1 + g2)
            # e il lettore ha ESENTATO tutte quelle uscite. Ogni altro motivo della riga resta NULLO come in A.
            m = re.match(r'^S1 KO: (\d+) uscite fuori ', nr[f])
            if m and int(m.group(1)) == F[f]['s1_tot'] and len(F[f]['esenti']) == F[f]['s1_tot'] and F[f]['s1_tot'] > 0:
                riga_s1_tolte[f] = nr[f]
                continue
        if nr.get(f):
            F[f]['nullo'].append('RIGA (RIEPILOGO): ' + nr[f][:300])
        elif f in nr and F[f]['nullo']:
            solo_qui.append(f)
    nulli = [f for f in FILE if F[f]['nullo']]
    L.append('  FILE NULLI (ricalcolati qui UNITI a quelli della riga): %s' % (', '.join(nulli) if nulli else 'nessuno'))
    if solo_qui:
        L.append('  DIVERGENZA: NULLI per il lettore ma NON per la riga: %s (si legge il motivo sopra: o la riga o il lettore sbaglia)' % ', '.join(solo_qui))
    if 'FILE NULLI' in riep:
        L.append('  [riga] ' + riep['FILE NULLI'][:600])
    if s1_festivi:
        L.extend(sezione_esenzioni(rc, F, riga_s1_tolte))
    conf_nulle = {cf for cf, (a, b) in CONF.items() if F[a]['nullo'] or F[b]['nullo']}
    L.append('')
    L.append('2. G0 E G2 (ricalcolati dai per-trade e dai CSV; accanto, quello che ha stampato la riga)')
    g0l = g0_long(rc, F) if rc.arch.get(794603) and rc.arch.get(794601) else dict(liv='NON VERIFICABILE', txt='archivi R246 assenti', verde=False, rosso=False)
    L.append('  G0-LONG R255w: ' + g0l['txt'])
    if 'G0-LONG' in riep:
        L.append('  [riga] ' + riep['G0-LONG'][:700])
    g0a_txt, g0a_ok = g0_ancora(F)
    L.append('  G0-ANCORA R255a: ' + g0a_txt)
    if 'G0-ANCORA' in riep:
        L.append('  [riga] ' + riep['G0-ANCORA'][:700])
    g0s, rosso_s = g0_sottoinsieme(F)
    L.append('  G0-SOTTOINSIEME (stesso orologio, per posizione, eccezione del lotto 0,10 par. 8):')
    for s in g0s:
        L.append('    ' + s)
    if 'G0-SOTTOINSIEME' in riep:
        L.append('  [riga] ' + riep['G0-SOTTOINSIEME'][:900])
    g0i, rosso_i = g0_ingressi(F)
    L.append('  G0-INGRESSI (uscite contro l ancora dello stesso orologio):')
    for s in g0i:
        L.append('    ' + s)
    if 'G0-INGRESSI' in riep:
        L.append('  [riga] ' + riep['G0-INGRESSI'][:900])
    g2, g2o, non_eseg = g2_manopole(F)
    L.append('  G2 LE MANOPOLE MORDONO (CSV _OOS, gemella g1):')
    for s in g2:
        L.append('    ' + s)
    L.append('  G2 L OROLOGIO MORDE (righe d inverno USA 15:30 contro 14:30, per close_time/deal_type/price):')
    for s in g2o:
        L.append('    ' + s)
    for k in ('G2 LE MANOPOLE', 'G2 L OROLOGIO'):
        if k in riep:
            L.append('  [riga] ' + riep[k][:900])
    L.append('')
    e_eff, e_is, e_oos, e_txt = e_eff_long(rc, F, g0l) if (rc.arch.get(794603) and rc.arch.get(794601)) else (E_MIN, None, None, 'archivi assenti: e_eff = %.4f' % E_MIN)
    L.append('3. IL MARGINE D ERRORE DELLA RICOMPOSIZIONE (par. 7, classe 800): ' + e_txt)
    non_confr = bool(g0l.get('rosso')) or g0l['liv'] == 'NON VERIFICABILE'
    if non_confr:
        L.append('   G0-LONG %s -> R1/R2 [NON CONFRONTABILI] per tutte le configurazioni (classe 750); R3 si legge lo stesso' % g0l['liv'])
    # DD_fisso del long per "EQUITY PEGGIO DEL LONG"
    rw = riga_g1(F, 'R255w')
    ddf_long = dd_fisso(rw) if rw else float('nan')
    L.append('   DD_fisso (|Profit/RF|) del CSV _OOS di R255w (long, gamba continua, banco 10000): %s EUR' % ('%.2f' % ddf_long if not math.isnan(ddf_long) else 'n.d.'))
    L.append('')
    L.append('4. LE TRE CURVE PER CONFIGURAZIONE (par. 7), per era; IN FASE decide, CONTROLLO = BCM a ora fissa, FTMO-DOC descrittiva')
    L.append('   tetti (par. 9, a saldo chiuso, denominatore 10000 fisso per il DD; saldo di inizio giornata per la giornata): R1 IS <= %.3f%%, R2 OOS <= %.3f%%, R3 >= %.2f%%; e_eff %.4f' % (R1_MAX, R2_MAX, R3_MIN, e_eff))
    ris = collections.OrderedDict()     # cf -> dict con curve, verdetti, stats
    for cf in CONF:
        f4, f5 = CONF[cf]
        L.append('')
        L.append('=== %s  (%s 14:30 / %s 15:30)%s' % (cf.upper(), f4, f5, '  [NULLA: %s]' % ', '.join(x for x in (f4, f5) if F[x]['nullo']) if cf in conf_nulle else ''))
        if cf in conf_nulle and F[f4]['nullo']:
            ris[cf] = dict(esito='NULLO', curve=None)
            L.append('  NULLA: nessuna curva (classe 772: un file che fallisce un cancello della catena non vota)')
            continue
        cv = curve_configurazione(F, cf)
        r = dict(curve=cv, esito=None, note=[])
        ris[cf] = r
        for nome in ('IN FASE', 'CONTROLLO', 'FTMO-DOC'):
            c = cv[nome]
            if c is None:
                L.append('  %s: NON RICOMPONIBILE (file 15:30 NULLO)' % nome)
                continue
            L.append('  %s (posizioni %d):' % (nome, c['scartati']))
            for era in ERE:
                ce = c[era]
                L.append('   era %-3s estate %d + inverno %d posizioni; sedute di confine (classe 805, RESTANO nella curva): %s'
                         % (era, ce['estate'], ce['inverno'], ', '.join('%s %+.2f' % (ds(d), n) for d, n in ce['confine']) or 'nessuna con posizione'))
                L.append(riga_curva('A ribas.', ce['A']))
                L.append(riga_curva('B denaro', ce['B']))
                L.append('  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): %.2f%%' % (ce.get('scarto_cont', 0.0) * 100))
        if s1_festivi:
            t_es, r['s1b'] = esenti_nelle_curve(F, cf, cv)
            L.append('  ' + t_es)
            L.extend(composizione_in_fase(cf, cv))
        # gambe intere e k
        for f, pp in ((f4, cv['p4']), (f5, cv['p5'])):
            if pp is None:
                continue
            cg = curva(pp, 'B')
            rr = riga_g1(F, f)
            ddf = dd_fisso(rr)
            k = ddf / cg['dd_eur'] if cg['dd_eur'] > 0 else float('nan')
            L.append('  gamba intera %s (corsa continua, denaro): %d pos, %d deal, Profit %.2f, DD chiuso %.2f EUR (%.3f%%), pegg %.3f%%, serie %d | CSV: EqDD %s%%, DD_fisso %.2f -> k = %.4f, Pegg CSV %s%%'
                     % (f, cg['n'], cg['deal'], cg['profit'], cg['dd_eur'], cg['dd_pct'], cg['pegg_pct'], cg['serie'], rr['Equity DD %'], ddf, k, rr['Peggior Giornata %']))
            vp = _valore_punto_r253(pp) if _valore_punto_r253 else []
            stops = [abs(p['net']) / p['vol'] for p in pp if len(p['deals']) == 1 and p['net'] < 0 and p['vol'] > 0]
            L.append('    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n %d%s; stop pieno mediano %s (n %d; in EUR/lotto, cambio EURUSD dentro: classe 823)'
                     % (len(vp), (', mediana %.3f EUR/pt/lotto (min %.3f max %.3f)' % (st.median(vp), min(vp), max(vp))) if vp else '', ('%.1f' % st.median(stops)) if stops else 'n.d.', len(stops)))
        # riscaldamento classe 834
        if cf in RISCALDA and cv['p4'] is not None:
            fer = feriali_da(ERE['IS'][0], RISCALDA[cf])
            for f, pp in ((f4, cv['p4']), (f5, cv['p5'])):
                if pp is None:
                    continue
                w = [p for p in pp if p['data'] in fer]
                L.append('  RISCALDAMENTO classe 834 (%s, primi %d feriali dal 2024.09.27 SENZA filtro maturo): %s: %d posizioni, P/L %+.2f%s'
                         % (cf, RISCALDA[cf], f, len(w), sum(p['net'] for p in w), (' (%s)' % ', '.join('%s %+.2f' % (ds(p['data']), p['net']) for p in w)) if w else ''))
        if cf == 'long':
            r['esito'] = 'RIFERIMENTO (nessun esito: il long non decide e non sposta i tetti; R255x = la casella d+1 del Dow, descrittiva)'
            L.append('  ESITO: ' + r['esito'])
            continue
        # -------- rischio sulla curva IN FASE
        c = cv['IN FASE']
        if c is None:
            r['esito'] = 'NULLO (file 15:30 NULLO: curva in fase non ricomponibile)'
            L.append('  ESITO: ' + r['esito'])
            continue
        cs, co = c['IS'], c['OOS']
        pegg_csv = [num(riga_g1(F, f)['Peggior Giornata %']) for f in (f4, f5)]
        pegg_csv_ok = all(not math.isnan(v) and v >= R3_MIN for v in pegg_csv)
        L.append('  R3-A (CSV _OOS Peggior Giornata %%): %s -> %s' % (' / '.join('%.4f' % v for v in pegg_csv), 'condizione sufficiente per il SOLO metodo A' if pegg_csv_ok else 'NON sufficiente: R3 solo dalla curva'))
        rr3, t3 = leggi_r3(cs, co, pegg_csv_ok)
        eq_peggio = (not math.isnan(ddf_long)) and dd_fisso(riga_g1(F, f4)) > ddf_long + EPS
        eq_txt = ' [EQUITY PEGGIO DEL LONG: DD_fisso %s %.2f > R255w %.2f]' % (f4, dd_fisso(riga_g1(F, f4)), ddf_long) if eq_peggio else ''
        verd = {}
        for tag, ce, S, nmin, tab in (('R1', cs, R1_MAX, N_R1, P_R1), ('R2', co, R2_MAX, N_R2, P_R2)):
            if non_confr:
                v = '[NON CONFRONTABILE] (G0-LONG %s)' % g0l['liv']
                verd[tag] = 'NON CONFRONTABILE'
            else:
                v = leggi_r1r2(ce['A']['dd_pct'], ce['B']['dd_pct'], S, e_eff, max(ce['A']['scarto_max'], ce['B']['scarto_max']), ce.get('scarto_cont'))
                verd[tag] = v.split(' ')[0]
                if v == 'RISPETTATO':
                    n = ce['A']['n']
                    if n >= nmin:
                        # classe 874: "RISCHIO PASSATO" e una frase della CONFIGURAZIONE (R1 n IS >= 60 E R2 n OOS >= 40 E R3), non del tetto
                        v = 'RISPETTATO su n = %d posizioni (>= %d, classe 804)' % (n, nmin)
                    else:
                        p, seg = p_noedge(tab, n)
                        v = 'NON VIOLATO su n = %d posizioni (P che un motore senza edge lo passi: %s%.2f; RISCHIO PASSATO solo da n >= %d)' % (n, '' if seg == '~' else seg, p, nmin)
                    v += ' A SALDO CHIUSO' + eq_txt
            L.append('  %s DD chiuso era %s: A %.3f%% / B %.3f%% contro %.3f%% con e_eff %.4f [min x (1-e) = %.3f, max x (1+e) = %.3f] -> %s'
                     % (tag, 'IS' if tag == 'R1' else 'OOS', ce['A']['dd_pct'], ce['B']['dd_pct'], S, e_eff, min(ce['A']['dd_pct'], ce['B']['dd_pct']) * (1 - e_eff), max(ce['A']['dd_pct'], ce['B']['dd_pct']) * (1 + e_eff), v))
        L.append('  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): %s' % t3)
        verd['R3'] = rr3
        n_is_, n_oos_ = cs['A']['n'], co['A']['n']
        if non_confr or 'VIOLATO' in (verd['R1'], verd['R2'], rr3) or verd['R1'] != 'RISPETTATO' or verd['R2'] != 'RISPETTATO':
            r['rischio'] = ''
        elif n_is_ >= N_R1 and n_oos_ >= N_R2:
            r['rischio'] = 'RISCHIO PASSATO (n IS = %d >= %d, n OOS = %d >= %d, R3 rispettato, classe 804)' % (n_is_, N_R1, n_oos_, N_R2)
        else:
            r['rischio'] = 'rischio NON VIOLATO su n IS = %d / n OOS = %d (RISCHIO PASSATO solo con n IS >= %d E n OOS >= %d, classe 804)' % (n_is_, n_oos_, N_R1, N_R2)
        if r['rischio']:
            L.append('  RISCHIO DELLA CONFIGURAZIONE: ' + r['rischio'])
        L.append('  SERIE PERDENTE (riportata, NON cancello, classe 804): IS %d / OOS %d (long 770202: 3 e 3 su 56 e 96)' % (cs['A']['serie'], co['A']['serie']))
        # rischio sul CONTROLLO (un fatto per quella sedia)
        cc = cv['CONTROLLO']
        vc = []
        for tag, ce, S in (('R1', cc['IS'], R1_MAX), ('R2', cc['OOS'], R2_MAX)):
            vc.append('%s %s (A %.3f / B %.3f, n %d)' % (tag, '[NON CONFRONTABILE]' if non_confr else leggi_r1r2(ce['A']['dd_pct'], ce['B']['dd_pct'], S, e_eff, max(ce['A']['scarto_max'], ce['B']['scarto_max']), ce.get('scarto_cont')).replace('RISPETTATO', 'NON VIOLATO'), ce['A']['dd_pct'], ce['B']['dd_pct'], ce['A']['n']))
        rc3, tc3 = leggi_r3(cc['IS'], cc['OOS'], num(riga_g1(F, f4)['Peggior Giornata %']) >= R3_MIN)
        L.append('  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): %s; R3 %s' % ('; '.join(vc), rc3))
        # -------- merito
        n_oos = co['A']['n']
        rif = RIF[cf]
        m = dict(M1=None, M2=None, M3=None)
        mtxt = []
        if rif[0] in ris and ris[rif[0]].get('curve') and ris[rif[0]]['curve'].get(rif[1]):
            cr = ris[rif[0]]['curve'][rif[1]]
            ro, ri = cr['OOS'], cr['IS']
            # testa par. 10 (classe 550): PF per posizione e sui deal TUTTI E DUE; ai lati opposti di una soglia = NON RISOLTO (None)
            def esito_pd(v_pos, v_deal):
                return v_pos if v_pos == v_deal else None

            def txt_m(v):
                return 'passa' if v is True else ('fallisce' if v is False else 'NON RISOLTO (per posizione e sui deal ai lati opposti, classe 550)')
            m['M1'] = esito_pd(co['A']['pf_pos'] >= 1.10 and co['B']['pf_pos'] >= 1.10, co['A']['pf_deal'] >= 1.10 and co['B']['pf_deal'] >= 1.10)
            mtxt.append('M1 PF OOS >= 1,10 (A e B): per posizione A %s / B %s, sui deal A %s / B %s -> %s' % (pf_txt(co['A']['pf_pos']), pf_txt(co['B']['pf_pos']), pf_txt(co['A']['pf_deal']), pf_txt(co['B']['pf_deal']), txt_m(m['M1'])))
            altro = (co['A']['ep'] > ro['A']['ep'])
            extra = ''
            if cf in USCITE:
                altro = altro and (co['A']['profit'] > ro['A']['profit']) and (co['A']['dd_pct'] <= ro['A']['dd_pct'])
                extra = ', Profit %.2f vs %.2f, DD %.3f vs %.3f (uscite: valgono anche Profit e DD)' % (co['A']['profit'], ro['A']['profit'], co['A']['dd_pct'], ro['A']['dd_pct'])
            m['M2'] = esito_pd(altro and co['A']['pf_pos'] >= ro['A']['pf_pos'] + 0.10, altro and co['A']['pf_deal'] >= ro['A']['pf_deal'] + 0.10)
            mtxt.append('M2 vs %s %s: PF OOS per posizione %s vs %s, sui deal %s vs %s (+0,10), EP %.2f vs %.2f%s -> %s' % (rif[0], rif[1], pf_txt(co['A']['pf_pos']), pf_txt(ro['A']['pf_pos']), pf_txt(co['A']['pf_deal']), pf_txt(ro['A']['pf_deal']), co['A']['ep'], ro['A']['ep'], extra, txt_m(m['M2'])))
            m['M3'] = esito_pd((cs['A']['pf_pos'] > ri['A']['pf_pos']) and (co['A']['pf_pos'] > ro['A']['pf_pos']),
                               (cs['A']['pf_deal'] > ri['A']['pf_deal']) and (co['A']['pf_deal'] > ro['A']['pf_deal']))
            mtxt.append('M3 concordanza: PF IS %s vs %s, PF OOS %s vs %s (per posizione; sui deal IS %s vs %s, OOS %s vs %s) -> %s' % (pf_txt(cs['A']['pf_pos']), pf_txt(ri['A']['pf_pos']), pf_txt(co['A']['pf_pos']), pf_txt(ro['A']['pf_pos']), pf_txt(cs['A']['pf_deal']), pf_txt(ri['A']['pf_deal']), pf_txt(co['A']['pf_deal']), pf_txt(ro['A']['pf_deal']), txt_m(m['M3'])))
        else:
            mtxt.append('M1-M3: riferimento %s (%s) NON DISPONIBILE (nullo o non ricomponibile)' % (rif[0], rif[1]))
        r['m'] = m
        r['verd'] = verd
        r['n_oos'] = n_oos
        r['n_is'] = cs['A']['n']
        # -------- esito
        if cf in non_eseg:
            esito = 'NON ESEGUITA (G2 fallito)'
        elif cf in rosso_s or cf in rosso_i:
            esito = 'NON LEGGIBILE (G0-%s ROSSO)' % ('SOTTOINSIEME' if cf in rosso_s else 'INGRESSI')
        elif non_confr:
            esito = '[NON CONFRONTABILE] (G0-LONG %s: R1/R2 non si leggono)%s' % (g0l['liv'], '; R3 VIOLATO' if rr3 == 'VIOLATO' else '')
        elif 'VIOLATO' in (verd['R1'], verd['R2']) or rr3 == 'VIOLATO':
            esito = 'BOCCIATA PER RISCHIO (%s; vale a qualunque n)' % ', '.join(t for t, v in (('R1', verd['R1']), ('R2', verd['R2']), ('R3', rr3)) if v == 'VIOLATO')
        elif 'NON' in verd['R1'] or 'NON' in verd['R2']:
            esito = 'RISCHIO NON RISOLTO (%s)' % ', '.join(t for t in ('R1', 'R2') if verd[t].startswith('NON'))
        else:
            passa_m = all(v is True for v in m.values())
            if n_oos < N_MERITO:
                esito = 'SOSPESA (posizioni OOS in fase %d < %d: merito SOSPESO)%s' % (n_oos, N_MERITO, ' -- INDIZIO FAVOREVOLE, merito sospeso (M1-M3 passati su n = %d)' % n_oos if passa_m else '')
            elif any(v is False for v in m.values()):
                esito = 'BOCCIATA PER MERITO (%s) su n = %d' % (', '.join(k for k, v in m.items() if v is False), n_oos)
            elif not passa_m:
                # classe 874: un NON RISOLTO (o un riferimento mancante) NON e una bocciatura
                esito = 'MERITO NON RISOLTO (%s: non passati e non falliti) su n = %d' % (', '.join(k for k, v in m.items() if v is not True), n_oos)
            else:
                esito = 'PASSA RISCHIO E MERITO su n = %d: M4 decide nella sez. 5' % n_oos
            if r.get('rischio'):
                esito += ' | ' + r['rischio']
        r['esito'] = esito
        r['passa_r'] = r.get('rischio', '').startswith('RISCHIO PASSATO')     # R1-R3 rispettati E n della classe 804
        r['passa_m'] = all(v is True for v in m.values()) and n_oos >= N_MERITO
        for s in mtxt:
            L.append('  ' + s)
        L.append('  ESITO %s: %s' % (cf, esito))
    # -------- M4 altopiano
    L.append('')
    L.append('5. M4 ALTOPIANO, MAI IL PICCO (par. 10)')
    L.extend(m4_altopiano(ris))
    # -------- riepilogo esiti
    L.append('')
    L.append('6. ESITI PER CONFIGURAZIONE (ordine del par. 10)')
    for cf in CONF:
        L.append('   %-7s %s' % (cf, ris.get(cf, {}).get('esito', 'NULLO')))
    batte = [cf for cf, r in ris.items() if cf != 'long' and r.get('m', {}).get('M2') is True]
    L.append('   LA MANOPOLA BATTE IL RIFERIMENTO (M2, oltre il rumore, calcolato anche sotto 150 ma allora e un INDIZIO): %s'
             % (', '.join(batte) if batte else 'NESSUNA MANOPOLA BATTE LO SHORT COME IL LONG OLTRE IL RUMORE'))
    if s1_festivi:
        L.append('   [LETTURA B: esiti con la S1 EMENDATA DOPO I NUMERI (classe 900), in attesa della firma di Claudio; la lettura valida senza firma e la A]')
        tot_if = {cf: r['s1b'].get('IN FASE', 0) for cf, r in ris.items() if r.get('s1b')}
        L.append('   CONTRO-ESEMPIO DELLA B (se le esenzioni fossero sbagliate): posizioni esentate dentro la curva IN FASE = %d in tutte le %d configurazioni lette (%s); '
                 'sbagliate, i numeri IN FASE non cambierebbero di un centesimo: cambierebbe SOLO se esistono (file NULLO -> configurazione NULLA, come in A). '
                 'L alternativa "ora 15 non arrivata" la misura G2 L OROLOGIO: righe d inverno 15:30 contro 14:30 DIVERSE in %d coppie su %d leggibili.'
                 % (sum(tot_if.values()), len(tot_if), ', '.join('%s %d' % kv for kv in tot_if.items()),
                    sum(1 for t in g2o if 'DIVERSE = ok' in t), sum(1 for t in g2o if 'NON VERIFICABILE' not in t)))
    L.append('   CERTIFICATO (09/09, par. 13): NON ANCORA MISURATO, MAI morto -- mancano i gemelli NASUSD/SPXUSD (punto 4) e il TF del grafico (punto 5); PF, n e DD e uscita ad asse: SI da questo round')
    # -------- 770212
    L.append('')
    L.append('7. COSA DICE PER LA 770212 (la sedia in firma = la configurazione ANCORA; curva FTMO-DOC, DESCRITTIVA: regola dell orologio FTMO documentata e NON misurata, griglia H4 diversa [NON MISURATO])')
    ra = ris.get('ancora', {})
    cv = ra.get('curve')
    if cv and cv.get('FTMO-DOC'):
        cd = cv['FTMO-DOC']
        for era in ERE:
            L.append('   era %s: ' % era + riga_curva('A', cd[era]['A']).strip())
            L.append('           ' + riga_curva('B', cd[era]['B']).strip())
        vd = []
        for tag, ce, S in (('R1', cd['IS'], R1_MAX), ('R2', cd['OOS'], R2_MAX)):
            vd.append('%s %s' % (tag, '[NON CONFRONTABILE]' if non_confr else leggi_r1r2(ce['A']['dd_pct'], ce['B']['dd_pct'], S, e_eff, max(ce['A']['scarto_max'], ce['B']['scarto_max']), ce.get('scarto_cont'))))
        rd3, td3 = leggi_r3(cd['IS'], cd['OOS'], False)
        L.append('   letti coi tetti del long (descrittivi): %s; R3 %s (%s)' % ('; '.join(vd), rd3, td3))
        L.append('   esito della configurazione ancora sulla curva IN FASE (quella che decide): %s' % ra.get('esito'))
        L.append('   differenza FTMO-DOC / IN FASE: i 40 feriali UE solare-USA legale presi dal file 15:30 (un ora DOPO la cash su FTMO col preset a 16:30, par. 6)')
    else:
        L.append('   NON RICOMPONIBILE (ancora NULLA o file 15:30 NULLO)')
    L.append('   NESSUNA PROPOSTA DI TAGLIA: i DD sono al banco 1% (deposito 10000); la scala alla taglia FTMO/BCM e un LIMITE SUPERIORE, non un identita (classe 547). Ogni esito e materiale per Claudio.')
    L.append('')
    L.append('8. COSA RESTA A MANO: classe 166 (SHA256 del motore) e rc dei job si leggono SOLO dal RIEPILOGO/REFERTO della riga; la data del cambio d ora FTMO e la sua griglia H4; i gemelli NASUSD/SPXUSD e il TF; il DD vero di un EA che cambia ora da solo (la curva in fase e RICOMPOSTA, par. 15).')
    return '\n'.join(L), dict(F=F, ris=ris, g0l=g0l, g0a=(g0a_txt, g0a_ok), e_eff=e_eff, e_is=e_is, e_oos=e_oos, non_eseg=non_eseg, rosso_s=rosso_s, rosso_i=rosso_i)


# ---------------------------------------------------------------- fixture per l'autotest
def _fixture_dir_default():
    cand = os.environ.get('CLAUDE_SCRATCHPAD')
    if cand and os.path.isdir(cand):
        return os.path.join(cand, 'lettori_r255')
    return os.path.join(tempfile.gettempdir(), 'lettori_r255')


def _scala_esatta(nets, totale):
    """scala i net cosi che la somma arrotondata al centesimo sia ESATTAMENTE totale (l'ultimo assorbe il resto)"""
    s = sum(nets)
    out = [round(v * totale / s, 2) for v in nets]
    out[-1] = round(out[-1] + (totale - sum(out)), 2)
    return out


def _sposta(t, giorni, ore=0):
    return t + dt.timedelta(days=giorni, hours=ore)


def _scrivi_pt(path, magic, deals):
    with open(path, 'w', newline='') as fh:
        fh.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n')
        for d in deals:
            fh.write('%s;%s;%d;%d;%d;%.2f;%.2f;%.2f\n' % (d['t'].strftime('%Y.%m.%d %H:%M:%S'), SIMB, magic, d['pid'], d['type'], d['vol'], d['price'], d['net']))


def _stat_csv(deals):
    """le colonne del CSV _OOS coerenti col per-trade (equity approssimata dal chiuso x 1,05)"""
    pos = posizioni([dict(d) for d in deals])
    c = curva(ribasa(pos), 'B')
    ddf = c['dd_eur'] * 1.05
    return dict(Profit='%.2f' % c['profit'], PF='%.5f' % (c['pf_deal'] if not math.isinf(c['pf_deal']) else 99.0),
                RF='%.5f' % (c['profit'] / ddf if ddf > 0 else 0.0), EqDD='%.4f' % (c['dd_pct'] * 1.05), Trades=str(len(deals)),
                Pegg='%.4f' % c['pegg_pct'], EP='%.5f' % (c['profit'] / max(1, len(deals))))


def genera_fixture(dest, variante, arch603, arch601):
    """costruisce una raccolta ROUND_R255_SHORT_DOW_INFASE_<variante>/ dagli archivi VERI 794603/794601.
    long (w) = R246 al centesimo (IS scalato a 260,71, OOS x0,10, struttura identica); short = righe
    invertite di segno (x0,03), date spostate di +7 giorni, deal_type 0; 15:30 = +1 ora e prezzo +1,0."""
    base = os.path.join(dest, 'ROUND_R255_SHORT_DOW_INFASE_' + variante)
    if os.path.isdir(base):
        shutil.rmtree(base)
    os.makedirs(os.path.join(base, 'PERTRADE'))
    # ---- il long w: struttura = archivio, lotti /10, IS scalato a 260,71
    dIS = [dict(d) for d in arch603]
    dOO = [dict(d) for d in arch601]
    for d in dIS + dOO:
        d['vol'] = round(d['vol'] / 10.0, 2)
        d['type'] = 1
    for d in dOO:
        d['pid'] += 1000          # position_id UNICI nella corsa continua (gli archivi ripartono tutti e due da 2)
    nIS = _scala_esatta([d['net'] for d in dIS], G0_LONG['sum_is'])
    for d, n in zip(dIS, nIS):
        d['net'] = n
    for d in dOO:
        d['net'] = round(d['net'] / 10.0, 2)
    # position_id continui nella corsa
    w = dIS + dOO
    # ---- la base short (nudo 14:30): segno invertito x0,04, +7 giorni, deal_type 0; oltre il 2026.06.30 si taglia
    nudo = []
    for d in arch603 + arch601:
        t = _sposta(d['t'], 7)
        if t.date() > dt.date(2026, 6, 30):
            continue
        nudo.append(dict(t=t, magic='', pid=d['pid'] + (0 if d in arch603 else 1000), type=0, vol=round(max(0.1, d['vol'] / 10.0), 2), price=d['price'], net=round(-d['net'] * 0.03, 2)))
    nudo.sort(key=lambda d: (d['t'], d['pid']))
    pn = posizioni(nudo)

    def da_pos(pp):
        out = [dict(d) for p in pp for d in p['deals']]
        out.sort(key=lambda d: (d['t'], d['pid']))
        return out

    def scegli(pp, era, target):
        """le prime posizioni dell'era fino a ESATTAMENTE target deal"""
        sel, tot = [], 0
        for p in pp:
            if era_di(p['data']) != era:
                continue
            if tot + len(p['deals']) <= target:
                sel.append(p)
                tot += len(p['deals'])
            if tot == target:
                break
        assert tot == target, (era, tot, target)
        return sel
    anc_pos = scegli(pn, 'IS', G0_ANCORA['deal_is']) + scegli(pn, 'OOS', G0_ANCORA['deal_oos'])
    ancora = da_pos(anc_pos)
    st_pos = {'stH4': [p for i, p in enumerate(pn) if i % 2 == 0], 'stH6': [p for i, p in enumerate(pn) if i % 3 == 0],
              'stH8': [p for i, p in enumerate(pn) if i % 4 == 0], 'stH12': [p for i, p in enumerate(pn) if i % 5 == 0],
              'stD1': [p for i, p in enumerate(pn) if i % 6 == 0]}     # stD1: pochi (n OOS < 40)
    # uscite: stessi giorni/posizioni dell'ancora
    parz0 = da_pos([dict(p, deals=[dict(p['deals'][-1], vol=p['vol'], net=round(p['net'], 2))]) for p in anc_pos])
    tp05, tp15, trail0 = [], [], []
    for p in anc_pos:
        ds = [dict(d) for d in p['deals']]
        t_par = max(ds[0]['t'] - dt.timedelta(minutes=20), ds[0]['t'].replace(hour=15, minute=6, second=0))
        if len(ds) == 1 and ds[0]['vol'] >= 0.2 and t_par < ds[0]['t']:      # tp05: una parziale in piu' (dentro la finestra S1)
            h = round(ds[0]['vol'] / 2, 2)
            tp05 += [dict(ds[0], t=t_par, vol=h, price=ds[0]['price'] - 5.0, net=round(ds[0]['net'] * 0.6, 2)),
                     dict(ds[0], vol=round(ds[0]['vol'] - h, 2), net=round(ds[0]['net'] * 0.5, 2))]
        else:
            tp05 += [dict(d, net=round(d['net'] * 1.01, 2)) for d in ds]
        if len(ds) == 2:                               # tp15: la parziale non arriva
            tp15.append(dict(ds[-1], vol=p['vol'], net=round(p['net'] * 0.99, 2)))
        else:
            tp15 += [dict(d, net=round(d['net'] * 0.99, 2)) for d in ds]
        trail0 += [dict(d, net=round(d['net'] * 0.97, 2)) for d in ds]
    for lst in (tp05, tp15, trail0):
        lst.sort(key=lambda d: (d['t'], d['pid']))
    base14 = {'ancora': ancora, 'nudo': nudo, 'parz0': parz0, 'tp05': tp05, 'tp15': tp15, 'trail0': trail0, 'long': w}
    for cf in ST_ORDINE:
        base14[cf] = da_pos(st_pos[cf])

    def a1530(deals, cf):
        out = []
        for d in deals:
            q = dict(d, t=_sposta(d['t'], 0, 1), price=d['price'] + 1.0, net=round(d['net'] * 1.02, 2))
            if variante == 'r3_solo_B' and cf == 'ancora' and not inverno_usa(q['t'].date()):
                q['net'] = round(abs(q['net']) * 5 + 50.0, 2)   # estate di b: gonfia il saldo della CORSA b (non e nella curva in fase)
            out.append(q)
        return out
    # ---- varianti
    if variante == 'r2_violato':
        for d in base14['ancora']:
            if era_di(d['t'].date()) == 'OOS':          # tutta l'era OOS dell'ancora (il file 15:30 ne deriva): DD x4
                d['net'] = round(d['net'] * 4.0, 2)
    # ---- scrittura
    pins_cache = {}
    prova_src = os.path.join(QUI, 'prove')
    for f, x in FILE.items():
        cf = x['cf']
        deals = [dict(d) for d in base14[cf]] if x['ora'] == '1430' else a1530(base14[cf], cf)
        if variante == 'r3_solo_B' and f == 'R255b':
            # una giornata d'inverno USA dell'era OOS con -115 EUR: A = -115/saldo corsa b (gonfiato) >= -1,10; B = -115/saldo curva (<= 10000) < -1,10
            cand = [d for d in deals if inverno_usa(d['t'].date()) and era_di(d['t'].date()) == 'OOS' and d['t'].date() >= dt.date(2025, 12, 1)]
            pid = cand[0]['pid']
            same = [d for d in deals if d['pid'] == pid]
            for d in same:
                d['net'] = 0.0
            same[-1]['net'] = -115.0
        rnd = os.path.join(base, 'ROUND_' + f)
        os.makedirs(rnd)
        for mg in (x['g1'], x['g2']):
            _scrivi_pt(os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, mg)), mg, deals)
        shutil.copy(os.path.join(prova_src, x['prova']), os.path.join(rnd, x['prova']))
        pin, asse, stringhe = leggi_pin_prova(os.path.join(prova_src, x['prova']))
        pins_cache[f] = pin
        s = _stat_csv([dict(d) for d in deals])
        cols = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades', 'Peggior Giornata %', 'Perdite Consecutive Max', 'Serie Perdente Peggiore', 'InpMagic'] + list(pin.keys()) + ['InpCorrSymbol', 'InpNewsFile']
        with open(os.path.join(rnd, '%s_%s_OOS_%s.csv' % (EA, SIMB, f)), 'w', newline='') as fh:
            fh.write(','.join(cols) + '\n')
            for i, mg in enumerate((x['g1'], x['g2'])):
                vals = [str(i), s['Profit'], s['EP'], s['PF'], s['RF'], '1.0', s['EqDD'], s['Trades'], s['Pegg'], '-3', '-100.00', str(mg)] + ['%g' % v for v in pin.values()] + ['SPXUSD', 'abtg_news.csv']
                fh.write(','.join(vals) + '\n')
        with open(os.path.join(rnd, 'REFERTO_ROUND_%s.txt' % f), 'w') as fh:
            fh.write('REFERTO fixture\ntetto barre: MaxBars=100000000\n')
        pis = os.path.join(rnd, '%s_%s_IS_%s.csv' % (EA, SIMB, f))
        if variante == 'is_operato' and f == 'R255c':
            with open(pis, 'w', newline='') as fh:
                fh.write(','.join(cols) + '\n' + ','.join(['0', '-12.00', '-12.0', '0.0', '0.0', '0.0', '0.12', '1', '-0.12', '-1', '-12.00', str(x['g1'])] + ['%g' % v for v in pin.values()] + ['SPXUSD', 'abtg_news.csv']) + '\n')
        else:
            open(pis, 'w').close()   # moncone vuoto (0 byte): ATTESO
    # archivi e riepilogo
    for mg, src in ((794603, arch603), (794601, arch601)):
        _scrivi_pt(os.path.join(base, 'archivio_R246_pertrade_%d.csv' % mg), mg, src)
    with open(os.path.join(base, 'RIEPILOGO_R255.txt'), 'w') as fh:
        fh.write('RIEPILOGO R255 -- fixture %s\nFILE NULLI (...): nessuno\nG0-LONG R255w (...): fixture\nCLASSE 166 (...): fixture, non verificato\n' % variante)
        for f in FILE:     # le righe di ESITO della riga, formato di RIGA_R255 (label.PadRight(6) + ' ' + rcTxt ... 'file NON nullo')
            fh.write('%s rc 2 (moncone _IS di un giorno = FALSO ALLARME ATTESO, _OOS verificato)   motore = pin (SHA256, 2 file)   prova = pin (SHA256) | G1 ok | L0 ok | S1 ok   file NON nullo\n' % f.ljust(6))
    return base


def autotest(fixture_dir):
    a603 = leggi_pertrade(os.path.join(QUI, 'risultati_archivio', 'R246', 'PERTRADE', 'abtg_trades_%s_%s_794603.csv' % (EA, SIMB)))
    a601 = leggi_pertrade(os.path.join(QUI, 'risultati_archivio', 'R246', 'PERTRADE', 'abtg_trades_%s_%s_794601.csv' % (EA, SIMB)))
    assert len(a603) == 74 and len(a601) == 130, (len(a603), len(a601))
    assert abs(sum(d['net'] for d in a603) - 2811.84) < 0.01 and abs(sum(d['net'] for d in a601) - 6721.93) < 0.01
    # i tetti del par. 9 si rifanno dagli archivi (denominatore 100000, metodo B): 4.693,54 e 4.271,61
    c603 = curva(ribasa(posizioni([dict(d) for d in a603]), 100000.0), 'B', 100000.0)
    c601 = curva(ribasa(posizioni([dict(d) for d in a601]), 100000.0), 'B', 100000.0)
    assert abs(c603['dd_eur'] - 4693.54) < 0.01 and abs(c601['dd_eur'] - 4271.61) < 0.01, (c603['dd_eur'], c601['dd_eur'])
    # peggior giornata col saldo di inizio giornata = -1,0062 / -1,0227 (par. 9)
    assert abs(c603['pegg_pct'] - (-1.0062)) < 0.0005 and abs(c601['pegg_pct'] - (-1.0227)) < 0.0005, (c603['pegg_pct'], c601['pegg_pct'])
    assert c603['n'] == 56 and c601['n'] == 96 and c603['serie'] == 3 and c601['serie'] == 3
    # calendario: i 40 feriali di disallineamento sono ESTATE USA e inverno UE
    assert not inverno_usa(dt.date(2025, 10, 28)) and inverno_ue(dt.date(2025, 10, 28))
    assert inverno_usa(dt.date(2025, 11, 3)) and not inverno_usa(dt.date(2025, 3, 10)) and inverno_usa(dt.date(2025, 3, 7))
    assert p_noedge(P_R1, 50)[0] == 0.45 and p_noedge(P_R2, 20)[0] == 0.77
    # classe 833 su curve costruite a mano: A rispetta, B viola
    pA = ribasa([dict(pid=1, deals=[dict(t=dt.datetime(2025, 12, 2, 16, 30), pid=1, type=0, vol=0.5, price=1.0, net=-115.0)], t0=dt.datetime(2025, 12, 2, 16, 30), t1=dt.datetime(2025, 12, 2, 16, 30), net=-115.0, vol=0.5, data=dt.date(2025, 12, 2))], 12000.0)
    cA, cB = curva(pA, 'A'), curva(pA, 'B')
    assert cA['pegg_pct'] > -1.10 and cB['pegg_pct'] < -1.10, (cA['pegg_pct'], cB['pegg_pct'])
    v3, t3 = leggi_r3(dict(A=cA, B=cB), dict(A=cA, B=cB), True)
    assert v3 == 'VIOLATO' and 'classe 833' in t3, t3
    assert leggi_r1r2(3.0, 3.2, 4.272, 0.1266, 0.0) == 'RISPETTATO' and leggi_r1r2(5.0, 5.2, 4.272, 0.1266, 0.0) == 'VIOLATO' and leggi_r1r2(4.0, 4.1, 4.272, 0.1266, 0.0) == 'NON RISOLTO'
    assert leggi_r1r2(4.0, 4.1, 4.272, 0.1266, 0.11).startswith('NON RISOLTO (d ufficio')
    esiti = {}
    for variante in ('pulito', 'r2_violato', 'r3_solo_B', 'is_operato'):
        base = genera_fixture(fixture_dir, variante, a603, a601)
        txt, o = referto(base)
        with open(os.path.join(fixture_dir, 'REFERTO_%s.txt' % variante), 'w') as fh:
            fh.write(txt)
        esiti[variante] = (txt, o)
        assert not any(F['nullo'] for F in o['F'].values()), [(f, F['nullo']) for f, F in o['F'].items() if F['nullo']]
        assert o['g0l']['verde'], o['g0l']['txt']            # long = R246 al centesimo
        assert o['g0a'][1], o['g0a'][0]                        # ancora 73/73
        assert not o['rosso_s'] and not o['rosso_i'], (o['rosso_s'], o['rosso_i'])
        assert not o['non_eseg'], o['non_eseg']
        assert abs(o['e_eff'] - E_MIN) < 1e-12 and o['e_is'] < E_MIN and o['e_oos'] < E_MIN, (o['e_eff'], o['e_is'], o['e_oos'])
    # caso pulito: short a rischio rispettato, n piccoli -> "NON VIOLATO su n" / RISCHIO PASSATO da n >= 40 (R2), merito sospeso
    txt, o = esiti['pulito']
    ra = o['ris']['ancora']
    assert ra['verd'] == dict(R1='RISPETTATO', R2='RISPETTATO', R3='RISPETTATO'), ra['verd']
    assert ra['esito'].startswith('SOSPESA'), ra['esito']
    assert ra['n_is'] < N_R1 and 'R1 DD chiuso era IS' in txt and 'NON VIOLATO su n = %d' % ra['n_is'] in txt, ra['n_is']
    rd = o['ris']['stD1']
    assert rd['n_oos'] < N_R2 and ('NON VIOLATO su n = %d posizioni' % rd['n_oos']) in txt, rd['n_oos']
    rn = o['ris']['nudo']
    # classe 874: R2 rispettato su n OOS >= 40 ma n IS < 60 -> la configurazione NON ha "RISCHIO PASSATO"
    assert rn['n_oos'] >= N_R2 and rn['n_is'] < N_R1 and 'RISPETTATO su n = %d posizioni (>= %d' % (rn['n_oos'], N_R2) in txt, rn['n_oos']
    assert 'RISCHIO PASSATO (n IS' not in rn['esito'] and 'rischio NON VIOLATO su n IS = %d / n OOS = %d' % (rn['n_is'], rn['n_oos']) in rn['esito'], rn['esito']
    assert not any(ln.lstrip().startswith(('R1 ', 'R2 ')) and 'RISCHIO PASSATO (' in ln for ln in txt.splitlines())
    assert 'cartelle ROUND_R255a..x trovate: 24 su 24' in txt and 'SHA256 del pin per i file prova: 24 letti dalla riga' in txt
    assert all(any(n.startswith('prova = pin (SHA256') for n in F['note']) for F in o['F'].values())
    assert 'moncone di UN giorno: vuoto ATTESO' in txt
    assert o['ris']['long']['esito'].startswith('RIFERIMENTO')
    assert 'NESSUNA PROPOSTA DI TAGLIA' in txt and 'COSA DICE PER LA 770212' in txt
    # R2 violato: ancora BOCCIATA PER RISCHIO (R2), a qualunque n; il CONTROLLO lo dice anche lui (estate = stesso file)
    txt, o = esiti['r2_violato']
    ra = o['ris']['ancora']
    assert ra['verd']['R2'] == 'VIOLATO' and ra['esito'].startswith('BOCCIATA PER RISCHIO (R2'), (ra['verd'], ra['esito'])
    assert o['ris']['nudo']['verd']['R2'] == 'RISPETTATO'     # il nudo non e toccato
    # R3 violato SOLO nel metodo B (classe 833): il CSV di b dice >= -1,10 (condizione sufficiente per A), B viola
    txt, o = esiti['r3_solo_B']
    ra = o['ris']['ancora']
    assert ra['verd']['R3'] == 'VIOLATO' and 'classe 833' in txt and ra['esito'].startswith('BOCCIATA PER RISCHIO (R3'), (ra['verd'], ra['esito'])
    cb = ra['curve']['IN FASE']['OOS']
    assert cb['A']['pegg_pct'] >= -1.10 and cb['B']['pegg_pct'] < -1.10, (cb['A']['pegg_pct'], cb['B']['pegg_pct'])
    assert 'condizione sufficiente per il SOLO metodo A' in txt
    # moncone che ha operato: si scrive, non annulla
    txt, o = esiti['is_operato']
    assert 'il 2024.09.26 HA OPERATO' in txt and not o['F']['R255c']['nullo']
    # contro-esempi sui cancelli: un per-trade con un deal LONG in un file short -> L0 NULLO; un pin cambiato -> P0 NULLO
    base = genera_fixture(fixture_dir, 'guasti', a603, a601)
    pk = os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, FILE['R255k']['g1']))
    righe = open(pk).read().splitlines()
    f = righe[1].split(';')
    f[4] = '1'
    righe[1] = ';'.join(f)
    open(pk, 'w').write('\n'.join(righe) + '\n')
    po = os.path.join(base, 'ROUND_R255g', '%s_%s_OOS_R255g.csv' % (EA, SIMB))
    rows = open(po).read().splitlines()
    hdr = rows[0].split(',')
    v = rows[1].split(',')
    v[hdr.index('InpTP1_R')] = '1.0'          # il pin 0,5 non e arrivato
    rows[1] = ','.join(v)
    open(po, 'w').write('\n'.join(rows) + '\n')
    txt, o = referto(base)
    assert any(s.startswith('L0') for s in o['F']['R255k']['nullo']) and any(s.startswith('G1') for s in o['F']['R255k']['nullo']), o['F']['R255k']['nullo']
    assert any(s.startswith('P0') for s in o['F']['R255g']['nullo']), o['F']['R255g']['nullo']
    assert o['ris']['trail0']['esito'] == 'NULLO' and o['ris']['tp05']['esito'] == 'NULLO'
    assert 'NON VERIFICABILE (un file e NULLO)' in txt
    # ---- contro-esempi del controllo preventivo del 27/09 (classi 872-875)
    # 872: la cartella PADRE della raccolta (zip scompattato in una sottocartella) -> si trova un livello sotto, non 24 NULLI
    padre = os.path.join(fixture_dir, 'zip_scompattato')
    if os.path.isdir(padre):
        shutil.rmtree(padre)
    shutil.copytree(os.path.join(fixture_dir, 'ROUND_R255_SHORT_DOW_INFASE_pulito'), os.path.join(padre, 'ROUND_R255_SHORT_DOW_INFASE_pulito'))
    txt, o = referto(padre)
    assert not any(F['nullo'] for F in o['F'].values()) and 'raccolta trovata UN livello sotto' in txt
    vuota = os.path.join(fixture_dir, 'cartella_sbagliata')
    os.makedirs(os.path.join(vuota, 'a'), exist_ok=True)
    os.makedirs(os.path.join(vuota, 'b'), exist_ok=True)
    try:
        referto(vuota)
        raise AssertionError('872: una cartella senza ROUND_R255* ha prodotto un referto')
    except SystemExit as e:
        assert 'RACCOLTA NON TROVATA' in str(e)
    # 873: la riga dice NULLO (motore diverso dal pin, classe 166) su un file che il lettore vede sano -> NULLO anche qui
    base = genera_fixture(fixture_dir, 'c166', a603, a601)
    rp = os.path.join(base, 'RIEPILOGO_R255.txt')
    t = open(rp).read().replace('R255c  rc 2 (moncone _IS di un giorno = FALSO ALLARME ATTESO, _OOS verificato)   motore = pin (SHA256, 2 file)',
                                'R255c  rc 2 (moncone _IS di un giorno = FALSO ALLARME ATTESO, _OOS verificato)   MOTORE DIVERSO DAL PIN: ABTG_Dow_Apertura_US.mq5 SHA256 DIVERSO DAL PIN')
    righe = t.splitlines()
    righe = [ln.replace('file NON nullo', 'FILE NULLO: MOTORE DIVERSO DAL PIN') if ln.startswith('R255c ') else ln for ln in righe]
    open(rp, 'w').write('\n'.join(righe) + '\n')
    # 873: una prova nella raccolta diversa dal pin -> P0 NULLO
    pv = os.path.join(base, 'ROUND_R255e', FILE['R255e']['prova'])
    open(pv, 'a').write('# riga in piu\n')
    txt, o = referto(base)
    assert any('MOTORE DIVERSO DAL PIN' in s for s in o['F']['R255c']['nullo']), o['F']['R255c']['nullo']
    assert o['ris']['nudo']['esito'] == 'NULLO', o['ris']['nudo']['esito']
    assert any('SHA256' in s and 'DIVERSO dal pin' in s for s in o['F']['R255e']['nullo']), o['F']['R255e']['nullo']
    # 875: G1 sul PF con la tolleranza della testa (|delta| <= 0,00005), non con l'arrotondamento a 4 decimali
    base = genera_fixture(fixture_dir, 'g1pf', a603, a601)
    po = os.path.join(base, 'ROUND_R255i', '%s_%s_OOS_R255i.csv' % (EA, SIMB))
    rows = open(po).read().splitlines()
    hdr = rows[0].split(',')
    for i, val in ((1, '1.234549'), (2, '1.234551')):     # delta 0,000002: stessa PF alla quarta decimale per la testa, round() li separa
        v = rows[i].split(',')
        v[hdr.index('Profit Factor')] = val
        rows[i] = ','.join(v)
    open(po, 'w').write('\n'.join(rows) + '\n')
    txt, o = referto(base)
    assert not o['F']['R255i']['nullo'], o['F']['R255i']['nullo']
    # 875: regola d'ufficio dello scarto > 10% anche su un DD che sarebbe VIOLATO (testa par. 7, R252a par. 5)
    assert leggi_r1r2(1.18 * 4.272, 1.19 * 4.272, 4.272, 0.1266, 0.12).startswith('NON RISOLTO (d ufficio')

    # 876: la corsa e' continua, la curva per era riparte da 10000: nell'era OOS lo scarto della LETTERA contiene
    # l'utile dell'era IS. Curva continua (metodo A): saldo == saldo della corsa -> scarto 0 per costruzione.
    _mk = lambda k, t, net: dict(pid=k, deals=[dict(t=t, pid=k, type=0, vol=0.5, price=1.0, net=net)], t0=t, t1=t, net=net, vol=0.5, data=t.date())
    _pos = ribasa([_mk(1, dt.datetime(2025, 1, 8, 16, 0), 1200.0), _mk(2, dt.datetime(2025, 7, 9, 16, 0), -50.0), _mk(3, dt.datetime(2025, 8, 6, 16, 0), 40.0)])
    _oos = [q for q in _pos if era_di(q['data']) == 'OOS']
    _lettera = curva(_oos, 'A')['scarto_max']
    _cont = max(sc for d, sc in curva(_pos, 'A')['scarti_pos'] if era_di(d) == 'OOS')
    assert abs(_lettera - 0.12) < 1e-9 and _cont < 1e-9, (_lettera, _cont)
    _v = leggi_r1r2(0.9 * R2_MAX, 0.9 * R2_MAX, R2_MAX, 0.0, _lettera, _cont)
    assert _v.startswith('NON RISOLTO (d ufficio') and 'classe 876' in _v, _v
    _v2 = leggi_r1r2(0.9 * R2_MAX, 0.9 * R2_MAX, R2_MAX, 0.0, _lettera)
    assert 'classe 876' not in _v2
    assert leggi_r1r2(1.18 * 4.272, 1.19 * 4.272, 4.272, 0.1266, 0.05) == 'VIOLATO'
    # 874: M4 decide la parola PROMOSSA (cella che sporge, centro, bordo TP1_R), e un NON RISOLTO non e una bocciatura
    def _r(passa):
        return dict(passa_r=passa, passa_m=passa, esito=('PASSA RISCHIO E MERITO su n = 160: M4 decide nella sez. 5' if passa else 'SOSPESA'))
    ris = collections.OrderedDict((cf, _r(cf in ('stH6', 'tp05', 'nudo'))) for cf in CONF if cf != 'long')
    m4_altopiano(ris)
    assert ris['stH6']['esito'].startswith('NON PROMOSSA') and 'sporge' in ris['stH6']['esito'], ris['stH6']['esito']
    assert ris['tp05']['esito'].startswith('NON PROMOSSA: M4, vince un BORDO'), ris['tp05']['esito']
    assert ris['nudo']['esito'].startswith('PROMOSSA AL PASSO DOPO (interruttore')
    ris = collections.OrderedDict((cf, _r(cf in ('stH6', 'stH8', 'stH12', 'stD1'))) for cf in CONF if cf != 'long')
    m4_altopiano(ris)
    assert ris['stH8']['esito'].startswith('PROMOSSA AL PASSO DOPO (centro') and ris['stH12']['esito'].startswith('NON PROMOSSA'), (ris['stH8']['esito'], ris['stH12']['esito'])
    assert not any('salvo M4' in r['esito'] for r in ris.values())
    # ---- LETTURA B (--s1-festivi): contro-esempi della S1 emendata dopo i numeri (classe 900)
    # calendario: riapertura CME in ora BCM (UTC+1 fisso), estate = 23:00 stesso giorno, inverno = 00:00 del giorno dopo, venerdi -> domenica
    assert riapertura_cme(dt.date(2025, 1, 9)) == dt.datetime(2025, 1, 10, 0, 0) and riapertura_cme(dt.date(2025, 6, 19)) == dt.datetime(2025, 6, 19, 23, 0)
    assert riapertura_cme(dt.date(2026, 5, 25)) == dt.datetime(2026, 5, 25, 23, 0) and riapertura_cme(dt.date(2025, 4, 18)) == dt.datetime(2025, 4, 20, 23, 0)
    assert all(fd.weekday() < 5 for fd in list(FESTIVI_ESENTI) + list(FESTIVI_PREVISTI)) and not set(FESTIVI_ESENTI) & set(FESTIVI_PREVISTI)
    base = genera_fixture(fixture_dir, 's1b', a603, a601)

    def _ritocca(f, cambi):
        """cambia il close_time di alcuni deal (indice nel per-trade, nuovo datetime o funzione) in g1 E g2: C0 e G1 restano ok"""
        for mg in (FILE[f]['g1'], FILE[f]['g2']):
            pth = os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, mg))
            rr = open(pth).read().splitlines()
            for i, nuovo in cambi:
                c = rr[1 + i].split(';')
                t = dt.datetime.strptime(c[0], '%Y.%m.%d %H:%M:%S')
                c[0] = (nuovo(t) if callable(nuovo) else nuovo).strftime('%Y.%m.%d %H:%M:%S')
                rr[1 + i] = ';'.join(c)
            open(pth, 'w').write('\n'.join(rr) + '\n')

    def _riga_s1(f, n):
        """la riga dice FILE NULLO per S1 (come nel RIEPILOGO vero di R255)"""
        rp = os.path.join(base, 'RIEPILOGO_R255.txt')
        rr = [ln.replace('file NON nullo', 'FILE NULLO: S1 KO: %d uscite fuori %s-%s (fixture)' % (n, FILE[f]['lo'], FILE[f]['hi'])) if ln.startswith(f + ' ') else ln
              for ln in open(rp).read().splitlines()]
        open(rp, 'w').write('\n'.join(rr) + '\n')
    # i tre casi VERI di R255 (come stanno nei per-trade dello zip): devono diventare ESENTI
    _ritocca('R255a', [(5, dt.datetime(2025, 1, 10, 0, 25, 27))])
    _riga_s1('R255a', 2)
    _ritocca('R255b', [(5, dt.datetime(2025, 6, 19, 23, 5, 0))])
    _riga_s1('R255b', 2)
    _ritocca('R255x', [(5, dt.datetime(2026, 5, 25, 23, 5, 0))])
    _riga_s1('R255x', 2)
    # il trail0 14:30 vero: due deal della stessa corsa, 01:19:52 (entro 1h30) e 03:26:04 (ne entro 1h30 ne prima uscita): resta NULLO
    _ritocca('R255k', [(5, dt.datetime(2025, 1, 10, 1, 19, 52)), (6, dt.datetime(2025, 1, 10, 3, 26, 4))])
    _riga_s1('R255k', 4)
    # contro-esempio 1: pin dell ora NON arrivato (file 15:30 corso a ora 14): il 60% delle uscite prima delle 16:05 -> NULLO anche in B
    nd = len(open(os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, FILE['R255d']['g1']))).read().splitlines()) - 1
    idx = list(range(0, nd, 5)) + list(range(1, nd, 5)) + list(range(2, nd, 5))
    _ritocca('R255d', [(i, (lambda t: t.replace(hour=15, minute=30, second=0))) for i in idx])
    _riga_s1('R255d', 2 * len(idx))
    # contro-esempio 2: 23:05 in un giorno NON festivo (mercoledi 2025.07.09), 23:05 del giorno DOPO Juneteenth (la stesura letterale
    # "giorno successivo" in estate), 23:05 del 2025.01.09 (il festivo d inverno PRIMA della riapertura delle 00:00): tutti NULLI
    _ritocca('R255f', [(5, dt.datetime(2025, 7, 9, 23, 5, 0))])
    _riga_s1('R255f', 2)
    _ritocca('R255h', [(5, dt.datetime(2025, 6, 20, 23, 5, 0))])
    _ritocca('R255j', [(5, dt.datetime(2025, 1, 9, 23, 5, 0))])
    # contro-esempio 3: TRE uscite post-festivo nello stesso per-trade (tutte entro 1h30 da Juneteenth): (c) -> nessuna esente, NULLO
    _ritocca('R255l', [(5, dt.datetime(2025, 6, 19, 23, 5, 0)), (6, dt.datetime(2025, 6, 19, 23, 10, 0)), (7, dt.datetime(2025, 6, 19, 23, 15, 0))])
    # contro-esempio 4: un festivo PREVISTO ma non in elenco (Presidents Day 2025, riapertura 2025.02.18 00:00): resta NULLO, e si scrive
    _ritocca('R255n', [(5, dt.datetime(2025, 2, 18, 0, 20, 0))])
    txtA, oA = referto(base)
    txtB, oB = referto(base, s1_festivi=True)
    FA, FB = oA['F'], oB['F']
    # A: la S1 alla lettera annulla tutti i file toccati (e la riga li annulla anche lei)
    for f in ('R255a', 'R255b', 'R255x', 'R255k', 'R255d', 'R255f', 'R255h', 'R255j', 'R255l', 'R255n'):
        assert any(x_.startswith('S1 ') for x_ in FA[f]['nullo']), (f, FA[f]['nullo'])
    assert 'LETTURA B' not in txtA and 'S1-B' not in txtA and '1-bis' not in txtA
    # B: i tre casi veri ESENTI, e il NULLO della riga tolto; stampati per nome
    for f, fest in (('R255a', 'lutto nazionale'), ('R255b', 'Juneteenth'), ('R255x', 'Memorial Day')):
        assert not FB[f]['nullo'], (f, FB[f]['nullo'])
        assert len(FB[f]['esenti']) == 2 and all(e[2] in FESTIVI_ESENTI for e in FB[f]['esenti']), FB[f]['esenti']
        assert any(ln.startswith('  ESENTE %s ' % f) and fest in ln for ln in txtB.splitlines()), f
    assert txtB.startswith('LETTURA B -- S1 EMENDATA DOPO I NUMERI, IN ATTESA DELLA FIRMA DI CLAUDIO') and 'CLASSE 900' in txtB
    assert 'NULLI DELLA RIGA TOLTI (unico motivo S1, conteggio uguale, tutte esentate): R255a, R255b, R255x' in txtB, [ln for ln in txtB.splitlines() if 'RIGA TOLTI' in ln]
    # trail0: 01:19:52 esente, 03:26:04 no -> NULLO, e la riga resta
    assert len(FB['R255k']['esenti']) == 2 and any('03:26:04' in x_ for x_ in FB['R255k']['nullo']) and any(x_.startswith('RIGA') for x_ in FB['R255k']['nullo']), FB['R255k']['nullo']
    # contro-esempio 1: pin non arrivato
    d5 = leggi_pertrade(os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA, SIMB, FILE['R255d']['g1'])))
    quota = sum(1 for d in d5 if d['t'].strftime('%H:%M:%S') < FILE['R255d']['lo']) / float(len(d5))
    assert quota >= 0.60 and not FB['R255d']['esenti'] and any(x_.startswith('S1 ') for x_ in FB['R255d']['nullo']), (quota, FB['R255d']['nullo'])
    # contro-esempio 2: 23:05 non festivo, giorno DOPO Juneteenth, festivo d inverno prima della riapertura
    for f in ('R255f', 'R255h', 'R255j'):
        assert not FB[f]['esenti'] and any(x_.startswith('S1 ') for x_ in FB[f]['nullo']), (f, FB[f]['nullo'])
    # contro-esempio 3: tre post-festivo -> (c)
    assert not FB['R255l']['esenti'] and any('c: 3 uscite candidate' in x_ for x_ in FB['R255l']['nullo']), FB['R255l']['nullo']
    # contro-esempio 4: festivo previsto non in elenco -> NULLO e OSSERVATO scritto
    assert not FB['R255n']['esenti'] and any(x_.startswith('S1 ') for x_ in FB['R255n']['nullo'])
    assert any('Presidents Day' in ln and 'OSSERVATO ma NON in elenco' in ln and '2025.02.18' in ln for ln in txtB.splitlines())
    # nessun file sano diventa nullo in B, e B non tocca gli altri cancelli: fuori dai file toccati i NULLI sono gli stessi di A
    toccati = {'R255a', 'R255b', 'R255x', 'R255k', 'R255d', 'R255f', 'R255h', 'R255j', 'R255l', 'R255n'}
    assert all(bool(FA[f]['nullo']) == bool(FB[f]['nullo']) == False for f in FILE if f not in toccati), [f for f in FILE if f not in toccati and (FA[f]['nullo'] or FB[f]['nullo'])]
    # B sul fixture pulito: nessuna esenzione, stessi esiti di A
    txtP, oP = referto(os.path.join(fixture_dir, 'ROUND_R255_SHORT_DOW_INFASE_pulito'), s1_festivi=True)
    assert 'nessuna esenzione' in txtP and {cf: r.get('esito') for cf, r in oP['ris'].items()} == {cf: r.get('esito') for cf, r in esiti['pulito'][1]['ris'].items()}
    # il deal esentato dentro la curva: la riga S1-B lo conta dove sta (R255a 2025.01.10 = inverno USA: CONTROLLO si, IN FASE no)
    assert oB['ris']['ancora']['s1b'] == {'IN FASE': 0, 'CONTROLLO': 1, 'FTMO-DOC': 0}, oB['ris']['ancora']['s1b']
    print('AUTOTEST OK: tetti dagli archivi (4.693,54 / 4.271,61; -1,0062 / -1,0227), calendario USA, classe 833, R1/R2 con e_eff, '
          'fixture pulito (G0-LONG VERDE, G0-ANCORA 73/73, e_eff = 0,1266, NON VIOLATO su n, R2 RISPETTATO su n>=40 ma NON "rischio passato", SOSPESA), R2 violato, R3 solo B, moncone operato, guasti L0/G1/P0; '
          'contro-esempi 872 (cartella sbagliata), 873 (NULLO della riga per classe 166, prova diversa dal pin), 874 (M4 e parole finali), 875 (G1 PF, regola d ufficio), 876 (scarto a curva continua accanto alla lettera); '
          'LETTURA B --s1-festivi (classe 900): tre festivi veri ESENTI e NULLO della riga tolto, trail0 03:26:04 resta NULLO, pin non arrivato (>= 60 per cento prima delle 16:05) NULLO, '
          '23:05 non festivo / giorno dopo Juneteenth / festivo d inverno prima delle 00:00 NULLI, 3 post-festivo NULLO (c), festivo previsto non in elenco NULLO e scritto, fixture pulito identico ad A')
    print('fixture e referti in %s' % fixture_dir)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='lettura di R255 dalla raccolta (criteri congelati, testa par. 7-17)')
    ap.add_argument('--raccolta', help='cartella ROUND_R255_SHORT_DOW_INFASE_AAAA-MM-GG (lo zip scompattato)')
    ap.add_argument('--out', help='scrive il referto anche in questo file')
    ap.add_argument('--autotest', action='store_true')
    ap.add_argument('--s1-festivi', action='store_true',
                    help='LETTURA B: S1 EMENDATA DOPO I NUMERI (classe 900), in attesa della firma di Claudio. Default SPENTA = lettura A, identica al byte')
    ap.add_argument('--fixture-dir', default=_fixture_dir_default())
    a = ap.parse_args()
    if a.autotest:
        os.makedirs(a.fixture_dir, exist_ok=True)
        autotest(a.fixture_dir)
        sys.exit(0)
    if not a.raccolta or not os.path.isdir(a.raccolta):
        ap.error('serve --raccolta <cartella> (oppure --autotest)')
    txt, _ = referto(a.raccolta, s1_festivi=a.s1_festivi)
    print(txt)
    if a.out:
        with open(a.out, 'w') as fh:
            fh.write(txt + '\n')
