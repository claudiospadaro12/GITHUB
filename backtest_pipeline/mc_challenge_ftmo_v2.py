#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_challenge_ftmo_v2.py -- 27/09/2026

IL MONTE CARLO DELLA CHALLENGE FTMO 541452707 CON I BLOCCHI PER GIORNATA,
LA SEDIA 770105 (DAX short) E L'ORO LONG 795301.
Referto: report/MC_CON_ORO_E_BLOCCHI_2026-09-27.md

NON modifica mc_challenge_ftmo_stato.py (v1) ne' i suoi due moduli: li IMPORTA
e ne RIUSA simula_stato(), pool_feriali(), le costanti dello stato del conto e
del Guardian di campo. SOLA LETTURA. NESSUNA PROPOSTA DI TAGLIA: le taglie
sono firme di Claudio, qui si stampano curve a taglie DATE.

I DUE BUCHI DELLA v1 CHE QUESTO FILE CHIUDE (o dichiara):
  (1) la v1 non conosce le sedie nuove: 770105 (DAX short, attaccata il 25/09),
      770212 (Dow short, in firma), ORO long (possibile 770421). Qui:
        770105 -> per-trade R251b/792520 [MISURATO], SOLO gamba OOS
                  2025.07.01 -> 2026.06.29, deposito 10.000, rischio 1%;
        ORO    -> per-trade R260a/795301 [MISURATO su OHLC], 2020.01.03 ->
                  2026.06.26, deposito 100.000, rischio 0,5%;
        770212 -> SENZA --r255: [NON MODELLATA] (nessun per-trade in repo; niente
                  proxy col segno cambiato: sarebbe un numero inventato).
                  CON --r255 <raccolta ROUND_R255_SHORT_DOW_INFASE_...>: per-trade
                  R255a/R255b (magic 793101 / 793102, deposito 10.000, rischio 1%),
                  curva FTMO-DOC dettata dal preset in firma (ora FISSA 16:30 FTMO),
                  IN FASE e CONTROLLO accanto come sensibilita'. Vedi il blocco
                  "770212 Dow short" sotto NON_MODELLATE per la mappa e le scale.
                  (cancello 28/09, classe 890) SOLO se: la pre-lettura di leggi_r255
                  (E0/P0/G1/C0/L0/S1 + NULLI della riga) dichiara R255a/R255b NON
                  nulli; il preset coincide con la prova R255a input per input
                  (salvo ora/chiusura, magic, rischio); il preset e' a 2,00%.
                  Le operazioni fuori dalle finestre A/B si ignorano e si dichiarano.
  (2) "trade indipendenti" (docs/RISPOSTA_GEMINI_2026-09-27.md par.2). Fatto
      misurato PRIMA di scrivere una riga: la v1 ricampiona GIA' GIORNATE
      INTERE (m.serie somma per giornata, simula_stato pesca giornate), quindi
      la correlazione intra-giornata fra le QUATTRO sedie della v1 e' GIA'
      conservata (lo dice anche il suo referto, par.6 punto 1). Il buco vero e'
      che le sedie NUOVE vanno agganciate PER DATA alla stessa giornata, non
      appese come pool indipendenti. Qui:
        - BLOCCHI  : unita' = giornata di borsa; tutti i trade di tutte le
                     sedie dello stesso giorno restano insieme (v1 estesa);
        - IID      : lo stesso calendario, ma il P/L di ogni POSIZIONE e'
                     estratto a caso dal pool della sua sedia (conteggio
                     giornaliero per sedia conservato, co-movimento distrutto).
                     E' il modello che Gemini critica, messo accanto per
                     MISURARE quanto vale la correlazione.
        - IID-S    : (aggiunto al cancello del 27/09) stesso calendario, ma il
                     TOTALE DI GIORNATA di ogni sedia presente e' estratto a caso
                     dalle giornate della STESSA sedia: distrugge SOLO il
                     co-movimento FRA sedie (il "crollo insieme" di Gemini) e
                     conserva quello DENTRO la sedia. Serve perche' l'IID per
                     posizione distrugge DUE cose: sulle 4 sedie v1 l'unica con
                     piu' posizioni al giorno e' la 771531 (77 giornate con >=2
                     posizioni, fino a 8, coppia di SELL LIMIT con SL comune), e
                     da sola vale +16 punti di PASS nell'IID per posizione.
        - DISEGNO  : BLK pesca giornate SENZA reimmissione (come la v1), IID e
                     IID-S pescano posizioni/giornate di sedia CON reimmissione.
                     Il confronto pulito (decomposizione in main e contro-esempio
                     iv) si fa con reimmissione=True per tutti e tre; nella
                     tabella il disegno misto vale da ~1 a ~3 punti (contro-
                     esempio i').

UNITA' (regole della v1): valore in frazione del deposito di misura, alla
taglia della misura; simula_stato moltiplica per `fattore` (2,0 = taglia 2,00%
delle sedie indici in campo) e applica la frazione fissa sul saldo del giorno.
  sedie v1     : net / 100.000                (misura 1%   -> x fattore)
  770105       : net /  10.000                (misura 1%   -> x fattore)
  ORO a t%     : net / 100.000 x (t/0,5) / fattore   (taglia ASSOLUTA t, non
                 segue il fattore: 0,5% e 1,0% del saldo, come chiesto)
  [classe 321] l'EA dimensiona sul SALDO CORRENTE del backtest: nella finestra A
  l'oro ha saldo 110.029-114.352, quindi dividere per 100.000 lo porta a ~0,55-0,57%
  effettivo (stop veri -535,56 e -558,68). Rinormalizzato sul saldo corrente l'effetto
  misurato e' <= 0,3 punti su tutte le righe oro: si dichiara, non si corregge (le
  4 sedie v1 hanno lo stesso effetto ereditato, saldi finali 106-123k).
Tutti i coefficienti sono potenze di due: le somme restano bit-per-bit uguali
alla v1 quando le sedie nuove pesano zero (contro-esempio iii).

CALENDARIO: universo = giorni FERIALI della finestra + le giornate con
operazioni (come pool_feriali della v1); una giornata senza operazioni vale 0 e
NON conta come trading day (attivo=False). "giorni" = giorni di borsa.
  finestra A : 2025.06.10 -> 2026.06.29  (le 4 sedie v1; l'oro ha 43 giornate)
  finestra B : 2025.07.01 -> 2026.06.29  (dove esiste anche la 770105)
  ORO INTERA STORIA: variante etichettata in cui l'oro e' pescato da un secondo
  calendario (2020.01.03 -> 2026.06.26) INDIPENDENTE dalla giornata indici:
  piu' regimi per l'oro, ma la correlazione oro-indici e' persa per costruzione.

USO:
  python3 backtest_pipeline/mc_challenge_ftmo_v2.py            # tabelle (~4 min), IDENTICHE a prima (senza 770212)
  python3 backtest_pipeline/mc_challenge_ftmo_v2.py --r255 <cartella ROUND_R255_SHORT_DOW_INFASE_AAAA-MM-GG>
        [--r255-curva {FTMO-DOC,IN FASE,CONTROLLO}]              # + le righe con la 770212 e le differenze con/senza (~6 min)
  python3 backtest_pipeline/mc_challenge_ftmo_v2.py --autotest [--fixture-dir DIR]
        # controlli e contro-esempi, compresa la fixture R255 finta (dagli archivi R246 794603/794601, segno invertito), poi esce
"""
import argparse, collections, csv, datetime as dt, os, random, shutil, statistics, sys, tempfile

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo as m                      # noqa: E402
import mc_challenge_ftmo_stato as st               # noqa: E402  (importa anche al)
import leggi_r255 as lr                            # noqa: E402  (RIUSO dichiarato: parser, FILE, Raccolta, curve, calendari)

BANCO, S_OGGI, SALDO_OGGI = st.BANCO, st.S_OGGI, st.SALDO_OGGI
G_GIORN, G_TOT, MIN_GIORNI = st.G_GIORN, st.G_TOT, st.MIN_GIORNI_RESTANTI
SEME, NSIM, SEMI_BANDA = st.SEME, st.NSIM, (12, 13, 14)
SLIP = st.SLIP_MISURATO
ANCORA_V1 = 57.2                 # report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md par.4 riga (a)

# sedia -> (percorso, deposito di misura, rischio di misura %, segue il fattore?)
SORGENTI_V2 = dict((n, (rel, m.DEPOSITO_MISURA, 1.0, True)) for n, rel in m.SORGENTI.items())
SORGENTI_V2['770105 DAXshort'] = (
    'risultati_archivio/R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv', 10000.0, 1.0, True)
SORGENTI_V2['795301 ORO'] = (
    'risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv',
    100000.0, 0.5, False)
V1 = list(m.SORGENTI)            # le quattro sedie della v1, nell'ordine di m.serie
NON_MODELLATE = ['770212 Dow short (in firma: nessun per-trade in repo, R255 non girato)',
                 '770260 Nasdaq (in campo, nessun per-trade: gia\' fuori dalla v1)',
                 '770511 SuperWave Dow (in campo, nessun per-trade: gia\' fuori dalla v1)']

# ---- 770212 Dow short: si modella SOLO con --r255 <raccolta ROUND_R255_SHORT_DOW_INFASE_...> (27/09/2026, sera)
#   per-trade   : leggi_r255.FILE['R255a']['g1'] = 793101 (file 14:30 BCM) e ['R255b']['g1'] = 793102 (file 15:30 BCM),
#                 deposito 10.000 (prova R255a r.22), rischio InpRiskPercent=1.0 (prova r.777, letto a runtime),
#                 corsa unica moncone 2024.09.26 + 641 giorni 2024.09.27 -> 2026.06.30.
#   sedia       : preset mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set (letto a runtime: ora di
#                 sessione, rischio, magic, lati = la FIRMA in attesa di Claudio, "dal preset in firma", non una proposta).
#   curva       : ora FISSA 16:30 sul server FTMO; FTMO e' IT+1 tutto l'anno (docs/REGOLAMENTO_FTMO_2026-08.md r.130:
#                 GMT+2 inverno / GMT+3 estate) -> segue il calendario UE -> sul BCM (UTC+1 fisso) e' 14:30 con UE
#                 legale e 15:30 con UE solare = la curva FTMO-DOC di leggi_r255 (inverno_ue -> file 15:30). Le altre
#                 due (IN FASE = calendario USA; CONTROLLO = 14:30 tutto l'anno) si stampano accanto come SENSIBILITA'.
#                 [DERIVATO dal regolamento, NON MISURATO sul feed FTMO]: la regola dell'orologio FTMO e' documentata,
#                 non misurata (leggi_r255 par. 7 la chiama DESCRITTIVA).
#   scala       : net / 10.000 (misura 1%) x fattore, come la 770105: a fattore 2,0 = InpRiskPercent=2.00 del preset.
#                 Il rischio per operazione si misura ingresso->SL (InpRiskMode=0, CLAUDE.md sez. Guardian) e l'EA
#                 dimensiona sul SALDO CORRENTE della corsa (classe 321): lo scarto del saldo di corsa da 10.000 si
#                 stampa (min/max B_corsa da leggi_r255.ribasa) e NON si corregge, come per l'oro e le 4 sedie v1.
#   finestra    : le operazioni FUORI dalle finestre A/B (era IS 2024.09.27 -> 2025.06.09, moncone, 2026.06.30) si
#                 IGNORANO e si DICHIARANO col loro numero: il calendario resta quello delle 4 sedie v1 (NON si allarga).
PRESET_770212 = os.path.join(QUI, '..', 'mql5', 'Presets', 'FTMO', 'ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set')
PROVA_R255A = os.path.join(QUI, 'prove', 'R255a_short_DOW_ancora_1430.txt')
N_770212 = '770212 DOWshort'
CURVE_770212 = ('FTMO-DOC', 'IN FASE', 'CONTROLLO')
SENS_770212 = dict((c, '770212 [%s]' % c) for c in CURVE_770212)


# ---------------------------------------------------------------- dati
def data(s):
    return dt.date(*map(int, s[:10].split('.')))


def carica_v2(nomi=None):
    """Per sedia: giornaliero (somma dei deal per data di chiusura, in ordine
       di file come m.carica) e posizioni (somma dei deal per position_id,
       datate all'ULTIMO deal)."""
    out = {}
    for nome in (nomi or SORGENTI_V2):
        rel, dep, rmis, segue = SORGENTI_V2[nome]
        gior = collections.defaultdict(float)
        pos = collections.OrderedDict()
        with open(os.path.join(QUI, rel), newline='') as fh:
            for r in csv.DictReader(fh, delimiter=';'):
                d = r['close_time'][:10]; x = float(r['net_profit'])
                gior[d] += x
                p = pos.setdefault(r['position_id'], [d, 0.0])
                p[0] = d; p[1] += x
        out[nome] = {'giorni': dict(gior), 'posizioni': [(d, x) for d, x in pos.values()],
                     'dep': dep, 'rmis': rmis, 'segue': segue}
    return out


# ---------------------------------------------------------------- 770212 da --r255
def leggi_preset_770212(path=PRESET_770212):
    """La FIRMA in attesa di Claudio, letta dal preset e NON proposta: {input: (valore, riga)}.
       Le righe di commento (;) non contano; una chiave che manca ferma tutto."""
    out = {}
    with open(path, encoding='utf-8', errors='replace') as fh:
        for i, riga in enumerate(fh, 1):
            r = riga.strip().lstrip('\ufeff')
            if not r or r.startswith(';') or '=' not in r:
                continue
            k, v = r.split('=', 1)
            k = k.strip()
            if k in ('InpSessionHour', 'InpSessionMin', 'InpRiskPercent', 'InpMagic', 'InpAllowShort', 'InpAllowLong',
                     'InpCloseHour', 'InpCloseMin', 'InpUsaGuardian', 'InpOneTradePerDay'):
                out[k] = (v.strip(), i)
    for k in ('InpSessionHour', 'InpSessionMin', 'InpRiskPercent', 'InpMagic', 'InpAllowShort', 'InpAllowLong'):
        if k not in out:
            raise SystemExit('preset 770212 senza la riga %s: %s -- la 770212 resta [NON MODELLATA]' % (k, path))
    return out


def _inp(path, preset):
    """Tutti gli input Inp* di un preset (.set) o di un file prova (valore prima di '||'): {input: valore}."""
    out = {}
    with open(path, encoding='utf-8', errors='replace') as fh:
        for riga in fh:
            r = riga.strip().lstrip('\ufeff')
            if not r.startswith('Inp') or '=' not in r:
                continue
            k, v = r.split('=', 1)
            out[k.strip()] = v.split('||')[0].strip()
    return out


# (cancello 28/09, classe 890) le SOLE differenze ammesse fra il preset in firma e la prova R255a: ora di sessione e di
# chiusura (stesso scarto: e' l'orologio), magic, rischio (la scala), e due stringhe che i loro interruttori spengono
# (InpUseCorrelation=false, InpUseNewsFilter=false). Qualunque altro input diverso = il per-trade NON e' la sedia.
PRESET_DIFF_AMMESSE = ('InpSessionHour', 'InpCloseHour', 'InpMagic', 'InpRiskPercent', 'InpCorrSymbol', 'InpNewsCurrencies')


def confronta_preset_prova(preset_path=PRESET_770212, prova_path=PROVA_R255A):
    """La LETTERA del preset contro la prova R255a, input per input: [] se il per-trade e' la sedia, altrimenti l'elenco
       delle differenze. Senza questo, un preset con un'altra gestione dell'uscita verrebbe modellato zitto con la curva
       R255 (lo stesso difetto che il rifiuto dell'ora evita, su tutti gli altri input)."""
    def n(v):
        try:
            return float(v)
        except ValueError:
            return v.lower()
    p, q = _inp(preset_path, True), _inp(prova_path, False)
    diff = []
    for k in sorted(set(p) | set(q)):
        if k in PRESET_DIFF_AMMESSE:
            continue
        if k not in p or k not in q:
            diff.append('%s solo nel%s' % (k, ' preset' if k in p else 'la prova'))
        elif n(p[k]) != n(q[k]):
            diff.append('%s preset=%s prova=%s' % (k, p[k], q[k]))
    for k, v in (('InpUseCorrelation', 'false'), ('InpUseNewsFilter', 'false')):
        if p.get(k, '').lower() != v:
            diff.append('%s=%s nel preset: la sua stringa non e\' piu\' spenta' % (k, p.get(k)))
    try:
        d_ses = (int(p['InpSessionHour']) * 60 + int(p['InpSessionMin'])) - (int(q['InpSessionHour']) * 60 + int(q['InpSessionMin']))
        d_chi = (int(p['InpCloseHour']) * 60 + int(p['InpCloseMin'])) - (int(q['InpCloseHour']) * 60 + int(q['InpCloseMin']))
        if d_ses != d_chi:
            diff.append('chiusura spostata di %+d min e sessione di %+d min: la durata della seduta non e\' quella della prova' % (d_chi, d_ses))
    except (KeyError, ValueError) as e:
        diff.append('ora di sessione/chiusura non leggibile (%s)' % e)
    return diff


def rischio_misura_r255(path=PROVA_R255A):
    """InpRiskPercent del file prova R255a (la MISURA del per-trade), letto e non ricordato: (valore, riga)."""
    with open(path, encoding='utf-8', errors='replace') as fh:
        for i, riga in enumerate(fh, 1):
            if riga.startswith('InpRiskPercent='):
                return float(riga.split('=', 1)[1].split('||')[0]), i
    raise SystemExit('prova R255a senza InpRiskPercent: %s' % path)


def curva_dal_preset(preset):
    """Quale curva del per-trade R255 rappresenta la sedia: decisa dalla LETTERA del preset.
       16:30 fisso sul server FTMO (IT+1 tutto l'anno) = calendario UE -> 14:30 BCM con UE legale, 15:30 con UE solare
       = FTMO-DOC (leggi_r255.curve_configurazione: inverno_ue -> file 15:30). Un'altra ora non ha una mappa scritta:
       si ferma, non si inventa."""
    h, mi = int(preset['InpSessionHour'][0]), int(preset['InpSessionMin'][0])
    if (h, mi) == (16, 30):
        return 'FTMO-DOC', ('InpSessionHour=16 (r.%d) InpSessionMin=30 (r.%d) = ora FISSA 16:30 sul server FTMO (IT+1 tutto '
                            'l\'anno) = 14:30 BCM con UE legale / 15:30 BCM con UE solare' % (
                                preset['InpSessionHour'][1], preset['InpSessionMin'][1]))
    raise SystemExit('preset 770212 con InpSessionHour=%d:%02d: la mappa sulle curve R255 e\' scritta solo per 16:30 FTMO; '
                     'con quest\'ora la 770212 resta [NON MODELLATA]' % (h, mi))


def carica_r255(cartella, curva=None, verifica=True, preset_path=PRESET_770212):
    """Carica i per-trade 793101 (14:30) e 793102 (15:30) dalla raccolta R255 e costruisce le tre curve nel formato
       di carica_v2 (giorni / posizioni / dep / rmis / segue). RIUSA leggi_r255: trova_raccolta (classe 872),
       Raccolta.path_pt, leggi_pertrade, curve_configurazione (posizioni + ribasa + selezione per calendario).
       curva=None -> quella dettata dal preset; un nome esplicito e' una SCELTA MANUALE e viene etichettata.
       verifica=True (SEMPRE in main): il CANCELLO del lettore, non solo il suo parser (classe 890) -- per R255a e R255b
       leggi_r255.pre_lettura_file (E0/P0/G1/C0/L0/S1) UNITO ai NULLI della riga (RIEPILOGO, classe 873): un file NULLO
       per il lettore e' un file ASSENTE qui. verifica=False solo nell'autotest, sulla fixture sintetica senza CSV."""
    base, nota = lr.trova_raccolta(cartella)
    rc = lr.Raccolta(base)
    preset = leggi_preset_770212(preset_path)
    if preset['InpAllowShort'][0].lower() != 'true' or preset['InpAllowLong'][0].lower() != 'false':
        raise SystemExit('preset 770212: InpAllowShort=%s InpAllowLong=%s: il per-trade R255 e\' SOLO SHORT, la 770212 resta [NON MODELLATA]' % (
            preset['InpAllowShort'][0], preset['InpAllowLong'][0]))
    auto, perche = curva_dal_preset(preset)
    scelta = curva or auto
    if float(preset['InpRiskPercent'][0]) != 2.0:
        raise SystemExit('preset 770212 r.%d: InpRiskPercent=%s: la scala di questo MC mette la 770212 alla taglia INDICI (fattore '
                         '2,0 = 2,00%% in campo); con un\'altra taglia in firma la riga "a fattore 2,0 = preset" sarebbe falsa -- '
                         'la 770212 resta [NON MODELLATA]' % (preset['InpRiskPercent'][1], preset['InpRiskPercent'][0]))
    diff = confronta_preset_prova(preset_path)
    if diff:
        raise SystemExit('preset 770212 DIVERSO dalla prova R255a oltre ora/magic/rischio (%s): il per-trade R255 NON e\' la sedia '
                         'in firma -- la 770212 resta [NON MODELLATA]' % '; '.join(diff[:6]))
    rmis, riga_rmis = rischio_misura_r255()
    if rmis != 1.0:
        raise SystemExit('prova R255a r.%d: InpRiskPercent=%s, non 1.0: le unita\' della v1 sono alla misura 1%% e questa scala '
                         'non e\' scritta -- la 770212 resta [NON MODELLATA]' % (riga_rmis, rmis))
    avvisi, nulli_lr = [], {}
    if verifica:
        rp = os.path.join(base, 'RIEPILOGO_R255.txt')
        riep = ''
        if os.path.exists(rp):
            with open(rp, encoding='utf-8', errors='replace') as fh:
                riep = fh.read()
        else:
            avvisi.append('RIEPILOGO_R255.txt ASSENTE: classe 166 (motore = pin), rc e freschezza NON VERIFICATI per R255a/R255b')
        nr = lr.nulli_della_riga(riep)
        for f in ('R255a', 'R255b'):
            o = lr.pre_lettura_file(rc, f)
            nulli_lr[f] = list(o['nullo'])
            if nr.get(f):
                nulli_lr[f].append('RIGA (RIEPILOGO): ' + nr[f][:300])
            elif riep and f not in nr:
                avvisi.append('%s: nessuna riga di ESITO nel RIEPILOGO: classe 166 e rc NON VERIFICATI' % f)
    F, deals = {}, {}
    for f in ('R255a', 'R255b'):
        g1 = lr.FILE[f]['g1']
        p = rc.path_pt(g1)
        if nulli_lr.get(f):
            F[f] = dict(pt={}, nullo=['NULLO per leggi_r255: ' + ' | '.join(nulli_lr[f])]); continue
        if not os.path.exists(p):
            F[f] = dict(pt={}, nullo=['per-trade assente: %s' % p]); continue
        d = lr.leggi_pertrade(p)
        tipi = sorted(set(x['type'] for x in d)); magic = sorted(set(x['magic'] for x in d))
        # controlli minimi (la pre-lettura piena E0/P0/G1/C0/L0/S1 e' di leggi_r255): lato SHORT = deal di chiusura BUY
        # (deal_type 0), magic = la gemella g1, almeno un deal
        if not d or tipi != [0] or magic != [str(g1)]:
            raise SystemExit('per-trade %s: deal_type %s, magic %s, %d deal: non e\' il lato SHORT della gemella g1 '
                             '(atteso deal_type [0], magic [%d]) -- la 770212 resta [NON MODELLATA]' % (p, tipi, magic, len(d), g1))
        F[f] = dict(pt={g1: d}, nullo=[]); deals[f] = d
    if F['R255a']['nullo']:
        raise SystemExit('senza il per-trade 14:30 (magic %d) la 770212 resta [NON MODELLATA]: %s' % (lr.FILE['R255a']['g1'], F['R255a']['nullo'][0]))
    cv = lr.curve_configurazione(F, 'ancora')
    curve = collections.OrderedDict()
    for nome in CURVE_770212:
        c = cv[nome]
        if c is None:
            curve[nome] = None; continue
        pos = sorted(c['IS']['pos'] + c['OOS']['pos'], key=lambda p: p['t0'])
        gior = collections.defaultdict(float)
        for p in pos:
            for x in p['deals']:
                gior[x['t'].strftime('%Y.%m.%d')] += x['net']
        curve[nome] = {'giorni': dict(gior), 'posizioni': [(p['data'].strftime('%Y.%m.%d'), p['net']) for p in pos],
                       'dep': lr.DEPOSITO, 'rmis': rmis, 'segue': True, 'pos_lr': pos,
                       'moncone': c['scartati'] - len(pos),
                       'b_corsa': (min(p['B_corsa'] for p in pos), max(p['B_corsa'] for p in pos)) if pos else (lr.DEPOSITO, lr.DEPOSITO)}
    if curve.get(scelta) is None:
        raise SystemExit('curva %s non costruibile (file 15:30, magic %d: %s): la 770212 resta [NON MODELLATA]; '
                         'con --r255-curva CONTROLLO (SCELTA MANUALE) si modella il solo file 14:30, che NON e\' la sedia '
                         'd\'inverno UE (14:30 BCM = 15:30 FTMO)' % (scelta, lr.FILE['R255b']['g1'], F['R255b']['nullo'][0][:300]))
    return dict(base=base, nota=nota, preset=preset, scelta=scelta, perche=perche, manuale=curva is not None, auto=auto,
                curve=curve, deals=deals, rmis=(rmis, riga_rmis), verifica=verifica, avvisi=avvisi,
                nulli_lr=dict((f, v) for f, v in nulli_lr.items() if v))


def aggiungi_770212(dati, r):
    """Mette la curva scelta in dati[N_770212] e le altre due come sensibilita' (chiavi SENS_770212)."""
    dati[N_770212] = r['curve'][r['scelta']]
    for c in CURVE_770212:
        if c != r['scelta'] and r['curve'][c] is not None:
            dati[SENS_770212[c]] = r['curve'][c]
    return dati


def fuori_finestra(posizioni, cal):
    """Posizioni [(data, net)] fuori dal calendario dato: (n_dentro, n_fuori, prima_fuori, ultima_fuori)."""
    lo, hi = cal[0], cal[-1]
    dentro = [d for d, _ in posizioni if lo <= d <= hi]
    fuori = [d for d, _ in posizioni if not (lo <= d <= hi)]
    return len(dentro), len(fuori), (min(fuori) if fuori else None), (max(fuori) if fuori else None)


def scala(nome, dati, fattore, taglia_oro):
    """Coefficiente che porta il net EUR della sedia nelle unita' di simula_stato."""
    s = dati[nome]
    if s['segue']:
        return 1.0 / s['dep']
    return (taglia_oro / s['rmis']) / (s['dep'] * fattore)


def calendario(dati, nomi, da=None, a=None):
    """Feriali della finestra + giornate con operazioni delle sedie scelte,
       come pool_feriali della v1 (finestra = dalla prima all'ultima operazione)."""
    con = set()
    for n in nomi:
        con |= set(d for d in dati[n]['giorni'] if (da is None or d >= da) and (a is None or d <= a))
    D = sorted(data(d) for d in con)
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    tutti = sorted(set(d for d in fer if d.weekday() < 5) | set(D))
    return [d.strftime('%Y.%m.%d') for d in tutti]


def blocchi(dati, nomi, cal, fattore, taglia_oro=0.0):
    """(fisso, attivo): valore della giornata e flag 'ha operato' (solo sedie a peso > 0).
       Le sedie che seguono il fattore si sommano PRIMA per deposito e si dividono
       DOPO (stessa aritmetica di m.serie); l'oro si aggiunge col suo coefficiente."""
    fisso, attivo = [], []
    gruppi = collections.OrderedDict()
    for n in nomi:
        if dati[n]['segue']:
            gruppi.setdefault(dati[n]['dep'], []).append(n)
    oro = [n for n in nomi if not dati[n]['segue']]
    for d in cal:
        v = 0.0
        for dep, gr in gruppi.items():
            v += sum(dati[n]['giorni'].get(d, 0.0) for n in gr) / dep
        for n in oro:
            v += dati[n]['giorni'].get(d, 0.0) * scala(n, dati, fattore, taglia_oro)
        fisso.append(v)
        att = any(d in dati[n]['giorni'] for n in nomi if dati[n]['segue'] or taglia_oro > 0)
        attivo.append(att)
    return fisso, attivo


def pool_posizioni(dati, nomi, cal, fattore, taglia_oro=0.0):
    """Per la variante IID: pool dei valori per posizione di ogni sedia (nella finestra)
       e conteggio delle posizioni chiuse per giornata e per sedia."""
    lo, hi = cal[0], cal[-1]
    pools, conta = {}, [dict() for _ in cal]
    idx = dict((d, i) for i, d in enumerate(cal))
    for n in nomi:
        if not dati[n]['segue'] and taglia_oro == 0:
            continue
        k = scala(n, dati, fattore, taglia_oro)
        pools[n] = [x * k for d, x in dati[n]['posizioni'] if lo <= d <= hi]
        for d, _ in dati[n]['posizioni']:
            if d in idx:
                conta[idx[d]][n] = conta[idx[d]].get(n, 0) + 1
    return pools, conta


def comp_sedia_giorno(dati, nomi, cal, fattore, taglia_oro=0.0):
    """IID-S: per ogni sedia PRESENTE nella giornata k estrae a caso il TOTALE di una
       giornata della stessa sedia (nella finestra). Presenza conservata, co-movimento
       FRA sedie distrutto, co-movimento DENTRO la sedia conservato."""
    lo, hi = cal[0], cal[-1]
    usa = [n for n in nomi if dati[n]['segue'] or taglia_oro > 0]
    pools = dict((n, [x * scala(n, dati, fattore, taglia_oro) for d, x in sorted(dati[n]['giorni'].items()) if lo <= d <= hi])
                 for n in usa)
    pres = [[n for n in usa if d in dati[n]['giorni']] for d in cal]

    def f(k, rnd):
        v = 0.0
        for n in pres[k]:
            pool = pools[n]
            v += pool[rnd.randrange(len(pool))]
        return v
    return f


def comp_iid(pools, conta):
    """Componitore della giornata k: per ogni sedia estrae a caso tante posizioni
       quante ne ha chiuse quel giorno. Conteggio conservato, co-movimento distrutto."""
    nomi = list(pools)

    def f(k, rnd):
        v = 0.0
        for n in nomi:
            c = conta[k].get(n, 0)
            pool = pools[n]
            for _ in range(c):
                v += pool[rnd.randrange(len(pool))]
        return v
    return f


# ---------------------------------------------------------------- simulatore
def simula_v2(fisso, fattore, saldo_iniziale=1.0, guardian=None, slip=1.0,
              n_sim=NSIM, seme=SEME, target=0.10, muro_stat=0.10, muro_gior=0.05,
              min_giorni=4, max_giorni=800, g_tot=None, attivo=None, orizzonte=5,
              stake_fisso=False, reimmissione=False, comp=None):
    """Copia di st.simula_stato con UN solo aggancio: comp(k, rnd) -> valore della
       giornata k (variante IID). Con comp=None consuma il generatore ESATTAMENTE
       come simula_stato (senza pausa/sost): e' la prima cosa che --autotest verifica."""
    rnd = random.Random(seme)
    N = len(fisso)
    idx = list(range(N))
    esiti = collections.Counter(); d_pass = []; d_fine = []
    entro = collections.Counter()
    for _ in range(n_sim):
        s = idx[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; gt = 0; esito = None; i = 0
        while esito is None:
            if reimmissione:
                k = rnd.randrange(N)
            else:
                if i >= len(s):
                    s2 = idx[:]; rnd.shuffle(s2); s = s + s2
                k = s[i]; i += 1
            b0 = bal
            v = fisso[k] if comp is None else comp(k, rnd)
            r = v * fattore
            if r < 0:
                r *= slip
            if stake_fisso:
                perdita = -r
                if guardian is not None and perdita > guardian:
                    r = -guardian
                bal = b0 + r
            else:
                perdita = -r * b0
                if guardian is not None and perdita > guardian:
                    perdita = guardian
                    r = -perdita / b0
                bal = b0 + r * b0
            g += 1
            if attivo is None or attivo[k]:
                gt += 1
            if (b0 - bal) > muro_gior:
                esito = 'MORTE_GIORNALIERA'
            elif g_tot is not None and bal <= 1.0 - g_tot:
                bal = 1.0 - g_tot; esito = 'FERMATA_GUARDIAN'
            elif bal < 1.0 - muro_stat:
                esito = 'MORTE_STATICA'
            elif bal >= 1.0 + target and gt >= min_giorni:
                esito = 'PASS'
            elif g >= max_giorni:
                esito = 'TIMEOUT'
        esiti[esito] += 1
        (d_pass if esito == 'PASS' else d_fine).append(g)
        if g <= orizzonte:
            entro[esito] += 1
    tot = float(sum(esiti.values()))
    return {'p': dict((k, 100.0 * v / tot) for k, v in esiti.items()),
            'med_pass': statistics.median(d_pass) if d_pass else None,
            'med_fine': statistics.median(d_fine) if d_fine else None,
            'entro': dict((k, 100.0 * v / tot) for k, v in entro.items())}


KW_CAMPO = dict(guardian=G_GIORN, g_tot=G_TOT, min_giorni=MIN_GIORNI)


def corsa(fisso, fattore, attivo=None, comp=None, seme=SEME, slip=1.0, sost=None, donatori=None):
    """Una riga della tabella: blocchi -> st.simula_stato (funzione della v1);
       IID -> simula_v2 con comp; oro indipendente -> st.simula_stato con sost/donatori."""
    kw = dict(KW_CAMPO); kw.update(attivo=attivo, seme=seme, slip=slip)
    if comp is not None:
        return simula_v2(fisso, fattore, S_OGGI, comp=comp, **kw)
    if sost is not None:
        kw.update(sost=sost, donatori=donatori)
    return st.simula_stato(fisso, fattore, S_OGGI, **kw)


def fine5(o):
    return sum(v for k, v in o['entro'].items() if k != 'PASS')


def riga_tab(nome, o, banda=None):
    p = o['p']
    s = ("  %-58s PASS %5.1f | FERM.G9,3 %5.1f | FTMO5gg %4.1f | FTMO10 %4.1f | fine<=5gg %4.1f | ggPASS %5s | ggFINE %5s" % (
        nome, p.get('PASS', 0), p.get('FERMATA_GUARDIAN', 0), p.get('MORTE_GIORNALIERA', 0),
        p.get('MORTE_STATICA', 0), fine5(o), o['med_pass'], o['med_fine']))
    if banda:
        s += " | semi 12-14: PASS %s" % "/".join("%.1f" % b['p'].get('PASS', 0) for b in banda)
    print(s)
    return s


# ---------------------------------------------------------------- costruzioni di comodo
def scenari(dati):
    """Tutti i pool della tabella, costruiti una volta."""
    S = collections.OrderedDict()
    calA = calendario(dati, V1)                                  # finestra A = v1
    calB = calendario(dati, V1 + ['770105 DAXshort'], da='2025.07.01')   # finestra B
    S['calA'], S['calB'] = calA, calB
    per = m.carica(); giorni, base = m.serie(per)
    S['G0_pool'] = (base, None)
    S['G0_fer'] = st.pool_feriali(giorni, base)
    for tag, nomi, cal in [('A4', V1, calA), ('B4', V1, calB), ('B5', V1 + ['770105 DAXshort'], calB)]:
        S[tag] = dict(nomi=nomi, cal=cal)
    # oro sull'intera storia: calendario proprio (feriali 2020 -> 2026)
    S['calORO'] = calendario(dati, ['795301 ORO'])
    return S


def pool_oro_intero(dati, fattore, taglia_oro, cal_oro):
    f, _ = blocchi(dati, ['795301 ORO'], cal_oro, fattore, taglia_oro)
    return f


def correlazione(dati, nomi, cal):
    """Descrittiva [MISURATO]: giornate con >=2 sedie in perdita insieme, e
       correlazione di Pearson fra coppie sui giorni in cui operano entrambe."""
    per = dict((n, dati[n]['giorni']) for n in nomi)
    neg2 = sum(1 for d in cal if sum(1 for n in nomi if per[n].get(d, 0.0) < 0) >= 2)
    op2 = sum(1 for d in cal if sum(1 for n in nomi if d in per[n]) >= 2)
    coppie = []
    for i, a in enumerate(nomi):
        for b in nomi[i + 1:]:
            comuni = [d for d in cal if d in per[a] and d in per[b]]
            if len(comuni) < 8:
                coppie.append((a, b, len(comuni), None, None)); continue
            xa = [per[a][d] for d in comuni]; xb = [per[b][d] for d in comuni]
            ma, mb = statistics.mean(xa), statistics.mean(xb)
            cov = sum((x - ma) * (y - mb) for x, y in zip(xa, xb))
            va = sum((x - ma) ** 2 for x in xa); vb = sum((y - mb) ** 2 for y in xb)
            rho = cov / (va * vb) ** 0.5 if va > 0 and vb > 0 else None
            insieme = sum(1 for x, y in zip(xa, xb) if x < 0 and y < 0)
            coppie.append((a, b, len(comuni), rho, insieme))
    return neg2, op2, coppie


# ---------------------------------------------------------------- righe della 770212 (solo con --r255)
def nomi_770212(scelta):
    """I nomi delle righe aggiunte (in un posto solo: la tabella e le differenze li leggono da qui)."""
    return collections.OrderedDict([
        ('A_blk', "BLK A: 4 sedie + 770212 (%s)" % scelta),
        ('A_oro05', "BLK A: 4 sedie + 770212 + ORO 0,5%"),
        ('A_oro10', "BLK A: 4 sedie + 770212 + ORO 1,0%"),
        ('A_iid', "IID A: 4 sedie + 770212, posizioni indipendenti"),
        ('A_iids', "IID-S A: 4 sedie + 770212, giornate di sedia indipendenti (solo FRA sedie)"),
        ('B_blk', "BLK B: 4 sedie + 770105 + 770212 (%s)" % scelta),
        ('B_oro05', "BLK B: 4 sedie + 770105 + 770212 + ORO 0,5%"),
        ('B_oro10', "BLK B: 4 sedie + 770105 + 770212 + ORO 1,0%"),
        ('B_iid', "IID B: 4 sedie + 770105 + 770212, posizioni indipendenti"),
        ('B_iids', "IID-S B: 4 sedie + 770105 + 770212, giornate di sedia indipendenti (solo FRA sedie)"),
        ('B_iid_oro', "IID B: 4 sedie + 770105 + 770212 + ORO 1,0%, posizioni indipendenti"),
        ('B_slip', "BLK B: 4 sedie + 770105 + 770212 + ORO 1,0%% + slittamento x%.3f" % SLIP),
        ('B_sens_IN FASE', "BLK B: 4 sedie + 770105 + 770212 [IN FASE] (sensibilita\': calendario USA)"),
        ('B_sens_CONTROLLO', "BLK B: 4 sedie + 770105 + 770212 [CONTROLLO] (sensibilita\': 14:30 BCM tutto l\'anno)"),
        ('B_sens_FTMO-DOC', "BLK B: 4 sedie + 770105 + 770212 [FTMO-DOC] (sensibilita\': calendario UE)")])


def righe_770212(dati, r255, calA, calB, fatt):
    """Le righe della tabella con la 770212 dentro, nello stesso formato (nome, pool, attivo, comp, sost, don)."""
    N = nomi_770212(r255['scelta'])
    R = []
    A5 = V1 + [N_770212]
    fA, aA = blocchi(dati, A5, calA, fatt)
    R.append((N['A_blk'], fA, aA, None, None, None))
    for t, k in ((0.5, 'A_oro05'), (1.0, 'A_oro10')):
        f, a = blocchi(dati, A5 + ['795301 ORO'], calA, fatt, t)
        R.append((N[k], f, a, None, None, None))
    p, c = pool_posizioni(dati, A5, calA, fatt)
    R.append((N['A_iid'], fA, aA, comp_iid(p, c), None, None))
    R.append((N['A_iids'], fA, aA, comp_sedia_giorno(dati, A5, calA, fatt), None, None))
    B6 = V1 + ['770105 DAXshort', N_770212]
    fB, aB = blocchi(dati, B6, calB, fatt)
    R.append((N['B_blk'], fB, aB, None, None, None))
    for t, k in ((0.5, 'B_oro05'), (1.0, 'B_oro10')):
        f, a = blocchi(dati, B6 + ['795301 ORO'], calB, fatt, t)
        R.append((N[k], f, a, None, None, None))
    p, c = pool_posizioni(dati, B6, calB, fatt)
    R.append((N['B_iid'], fB, aB, comp_iid(p, c), None, None))
    R.append((N['B_iids'], fB, aB, comp_sedia_giorno(dati, B6, calB, fatt), None, None))
    p, c = pool_posizioni(dati, B6 + ['795301 ORO'], calB, fatt, 1.0)
    f, a = blocchi(dati, B6 + ['795301 ORO'], calB, fatt, 1.0)
    R.append((N['B_iid_oro'], f, a, comp_iid(p, c), None, None))
    R.append((N['B_slip'], f, a, None, None, 'slip'))
    for cv in CURVE_770212:
        if cv != r255['scelta'] and SENS_770212[cv] in dati:
            f, a = blocchi(dati, V1 + ['770105 DAXshort', SENS_770212[cv]], calB, fatt)
            R.append((N['B_sens_' + cv], f, a, None, None, None))
    return R


def delta_770212(ris, senza, con):
    """PASS(con) - PASS(senza) al seme principale e, se c'e' la banda, su ogni seme: (d, [d12, d13, d14])."""
    (o1, b1), (o2, b2) = ris[senza], ris[con]
    d = o2['p'].get('PASS', 0) - o1['p'].get('PASS', 0)
    banda = None
    if b1 and b2:
        banda = [y['p'].get('PASS', 0) - x['p'].get('PASS', 0) for x, y in zip(b1, b2)]
    return d, banda


def frase_delta(d, banda):
    """(cancello 28/09) il VERBO e' un verdetto: 'aggiunge'/'toglie' solo se TUTTI i semi stanno dallo stesso lato dello
       zero; se la banda lo attraversa la frase dice che il segno non si distingue dal rumore del seme; senza banda
       (taglie 1,00 / 0,65) lo dice."""
    semi = "semi %d/%s" % (SEME, "/".join(str(x) for x in SEMI_BANDA))
    if banda:
        tutti = [d] + banda
        lo, hi = min(tutti), max(tutti)
        if lo < 0 < hi or round(lo, 1) == 0.0 or round(hi, 1) == 0.0:
            return "NON si distingue dal rumore del seme: da %+.1f a %+.1f punti di PASS (%s)" % (lo, hi, semi)
        return "%s %.1f punti di PASS (%s: da %+.1f a %+.1f)" % ('aggiunge' if d > 0 else 'toglie', abs(d), semi, lo, hi)
    if round(d, 1) == 0.0:
        return "non sposta il PASS (%+.2f punti, seme %d solo: banda non calcolata a questa taglia)" % (d, SEME)
    return "%s %.1f punti di PASS (seme %d solo: banda NON calcolata a questa taglia, il segno non e' provato contro il rumore)" % (
        'aggiunge' if d > 0 else 'toglie', abs(d), SEME)


def stampa_delta_770212(ris, r255):
    """La frase "la 770212 aggiunge/toglie X punti" con l'intervallo del seme, per ogni coppia con/senza."""
    N = nomi_770212(r255['scelta'])
    coppie = [("A, blocchi", "BLK A: 4 sedie a blocchi giornalieri (== G0f)", N['A_blk']),
              ("A, blocchi + ORO 1,0%", "BLK A: 4 sedie + ORO 1.0% (43 giornate oro, agganciate per data)", N['A_oro10']),
              ("A, IID (posizioni indipendenti)", "IID A: 4 sedie, posizioni indipendenti (modello 'trade indipendenti')", N['A_iid']),
              ("B, blocchi", "BLK B: 4 sedie + 770105 (DAX short, 181 giornate)", N['B_blk']),
              ("B, blocchi + ORO 0,5%", "BLK B: 4 sedie + 770105 + ORO 0.5%", N['B_oro05']),
              ("B, blocchi + ORO 1,0%", "BLK B: 4 sedie + 770105 + ORO 1.0%", N['B_oro10']),
              ("B, IID (posizioni indipendenti)", "IID B: 4 sedie + 770105, posizioni indipendenti", N['B_iid']),
              ("B, IID-S (solo FRA sedie)", "IID-S B: 4 sedie + 770105, giornate di sedia indipendenti (solo FRA sedie)", N['B_iids']),
              ("B, blocchi + ORO 1,0% + slittamento", "BLK B: 4 sedie + 770105 + ORO 1,0%% + slittamento x%.3f" % SLIP, N['B_slip'])]
    print("  -- 770212 (%s) con/senza, stessa finestra e stesso seme --" % r255['scelta'])
    for tag, senza, con in coppie:
        if senza not in ris or con not in ris:
            print("     %-38s [riga mancante: %s]" % (tag, senza if senza not in ris else con)); continue
        d, banda = delta_770212(ris, senza, con)
        print("     %-38s la 770212 %s" % (tag, frase_delta(d, banda)))
    # scomposizione IID vs blocchi: quanto vale il co-movimento CON la 770212 dentro, accanto a quello SENZA
    for tag, blk, iid in [("B senza 770212", "BLK B: 4 sedie + 770105 (DAX short, 181 giornate)", "IID B: 4 sedie + 770105, posizioni indipendenti"),
                          ("B con 770212", N['B_blk'], N['B_iid']),
                          ("A senza 770212", "BLK A: 4 sedie a blocchi giornalieri (== G0f)", "IID A: 4 sedie, posizioni indipendenti (modello 'trade indipendenti')"),
                          ("A con 770212", N['A_blk'], N['A_iid'])]:
        if blk in ris and iid in ris:
            d, banda = delta_770212(ris, blk, iid)
            print("     IID - blocchi, %-24s %+.1f punti%s" % (tag, d, (" (semi: %s)" % "/".join("%+.1f" % x for x in banda)) if banda else ''))
    for cv in CURVE_770212:
        k = 'B_sens_' + cv
        if cv != r255['scelta'] and N[k] in ris:
            d, banda = delta_770212(ris, N['B_blk'], N[k])
            print("     sensibilita\' %-10s - %-10s %+.1f punti%s" % (cv, r255['scelta'], d, (" (semi: %s)" % "/".join("%+.1f" % x for x in banda)) if banda else ''))


# ---------------------------------------------------------------- autotest
def autotest(fixture_dir=None):
    ok = True
    fixture_dir = fixture_dir or fixture_dir_default()

    def chk(nome, cond, dettaglio=''):
        nonlocal ok
        print("  [%s] %s %s" % ('PASS' if cond else 'FAIL', nome, dettaglio))
        ok = ok and cond

    print("AUTOTEST mc_challenge_ftmo_v2.py")
    dati = carica_v2()
    S = scenari(dati)
    calA, calB = S['calA'], S['calB']
    base, _ = S['G0_pool']; fer_pool, fer_att = S['G0_fer']

    # 0. la v1 e' ancora quella: 57,2% dallo stato di oggi (ancora G0)
    o = corsa(base, 2.0)
    chk("G0: v1 riprodotta, PASS 57,2%% (pool 242 giornate)", abs(o['p']['PASS'] - ANCORA_V1) < 0.05,
        "-> %.4f%%" % o['p']['PASS'])
    # 1. simula_v2 con comp=None == st.simula_stato bit per bit (anche con attivo, slip, g_tot)
    for pool, att, sl in [(base, None, 1.0), (fer_pool, fer_att, 1.0), (fer_pool, fer_att, SLIP)]:
        a = st.simula_stato(pool, 2.0, S_OGGI, attivo=att, slip=sl, **KW_CAMPO)
        b = simula_v2(pool, 2.0, S_OGGI, attivo=att, slip=sl, **KW_CAMPO)
        chk("simula_v2(comp=None) == st.simula_stato (n=%d, slip %.3f)" % (len(pool), sl), a == b,
            "-> %.4f%% / %.4f%%" % (a['p']['PASS'], b['p']['PASS']))
    # 2. rovina del giocatore, come nella v1 (passi 1/64, puntata fissa, iid)
    u = 1.0 / 64
    o = simula_v2([u, -u], 1.0, 60 / 64, g_tot=0.093, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True, reimmissione=True)
    chk("rovina con Guardian 9,3%: P(PASS)=2/13=15,38%", abs(o['p'].get('PASS', 0) - 100 * 2 / 13) < 0.8,
        "-> %.2f%%, resto FERMATA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('FERMATA_GUARDIAN', 0)))
    o = simula_v2([u, -u], 1.0, 60 / 64, g_tot=None, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True, reimmissione=True)
    chk("rovina senza Guardian (muro 10%): P(PASS)=3/14=21,43%", abs(o['p'].get('PASS', 0) - 100 * 3 / 14) < 0.8,
        "-> %.2f%%, resto STATICA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('MORTE_STATICA', 0)))
    # 3. il costruttore a blocchi con le 4 sedie v1 == pool_feriali della v1, bit per bit
    fA, aA = blocchi(dati, V1, calA, 2.0)
    chk("blocchi(4 sedie, finestra A) == pool_feriali v1 (%d voci, %d a zero)" % (len(fer_pool), sum(1 for a in fer_att if not a)),
        fA == fer_pool and aA == fer_att and len(calA) == 277)
    # 4. somme: giornaliero == posizioni, per ogni sedia; date e conteggi dichiarati
    for n in SORGENTI_V2:
        sg = sum(dati[n]['giorni'].values()); sp = sum(x for _, x in dati[n]['posizioni'])
        chk("%-16s somma giornaliero == somma posizioni (%+.2f), %d posizioni, %d giornate, %s -> %s" % (
            n, sg, len(dati[n]['posizioni']), len(dati[n]['giorni']), min(dati[n]['giorni']), max(dati[n]['giorni'])),
            abs(sg - sp) < 1e-6)
    chk("770105: 181 posizioni, 2025.07.01 -> 2026.06.29, somma +254,74 (RIEPILOGO_R251)",
        len(dati['770105 DAXshort']['posizioni']) == 181 and abs(sum(dati['770105 DAXshort']['giorni'].values()) - 254.74) < 0.005)
    chk("ORO: 279 posizioni, 375 deal (referto CORTI B), 2020.01.03 -> 2026.06.26",
        len(dati['795301 ORO']['posizioni']) == 279 and min(dati['795301 ORO']['giorni']) == '2020.01.03')
    n_oroA = sum(1 for d in calA if d in dati['795301 ORO']['giorni'])
    chk("oro nella finestra A: 43 giornate con operazioni su %d di calendario" % len(calA), n_oroA == 43, "-> %d" % n_oroA)
    chk("finestra B: %d giorni di borsa, 770105 presente in 181" % len(calB),
        calB[0] == '2025.07.01' and sum(1 for d in calB if d in dati['770105 DAXshort']['giorni']) == 181)
    # 5. scala: una giornata con un solo trade oro -500 EUR a 0,5% -> -0,5% del saldo (fattore 2); a 1,0% -> -1,0%
    finto = {'795301 ORO': dict(dati['795301 ORO'])}
    finto['795301 ORO']['giorni'] = {'2030.01.01': -500.0}
    f05, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 2.0, 0.5)
    f10, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 2.0, 1.0)
    chk("scala oro: -500 EUR -> -0,5%% (t=0,5) / -1,0%% (t=1,0) a fattore 2", f05[0] * 2.0 == -0.005 and f10[0] * 2.0 == -0.01,
        "-> %.6f / %.6f" % (f05[0] * 2.0, f10[0] * 2.0))
    f05b, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 1.0, 0.5)
    chk("scala oro NON segue il fattore: a fattore 1 resta -0,5%", f05b[0] * 1.0 == -0.005)
    finto2 = {'770105 DAXshort': dict(dati['770105 DAXshort'])}
    finto2['770105 DAXshort']['giorni'] = {'2030.01.01': -100.0}
    fs, _ = blocchi(finto2, ['770105 DAXshort'], ['2030.01.01'], 2.0)
    chk("scala 770105: -100 EUR su 10.000 = -1%% di misura -> -2%% a fattore 2", fs[0] * 2.0 == -0.02)
    # 6. CONTRO-ESEMPIO (iii): oro a taglia 0 == senza oro, bit per bit (stessa finestra A)
    f0, a0 = blocchi(dati, V1 + ['795301 ORO'], calA, 2.0, 0.0)
    chk("(iii) blocchi con oro a taglia 0 == blocchi senza oro (valori e attivo, bit per bit)", f0 == fA and a0 == aA)
    o0 = corsa(f0, 2.0, attivo=a0); oA = corsa(fA, 2.0, attivo=aA)
    chk("(iii) ... e la tabella e' identica", o0 == oA, "-> %.4f%% / %.4f%%" % (o0['p']['PASS'], oA['p']['PASS']))
    # 7. CONTRO-ESEMPIO (i): un solo trade per giorno -> blocchi == IID entro il rumore
    #    universo sintetico: OGNI posizione delle 4 sedie e' la sua giornata (560 giornate, tutte attive)
    pos1 = [(n, x) for n in V1 for _, x in dati[n]['posizioni']]
    f1 = [x / dati[n]['dep'] for n, x in pos1]
    pools1 = dict((n, [x / dati[n]['dep'] for nn, x in pos1 if nn == n]) for n in V1)
    conta1 = [{n: 1} for n, _ in pos1]
    ob = simula_v2(f1, 2.0, S_OGGI, reimmissione=True, **KW_CAMPO)                       # bootstrap dei blocchi
    oi = simula_v2(f1, 2.0, S_OGGI, reimmissione=True, comp=comp_iid(pools1, conta1), **KW_CAMPO)
    # nota: qui l'IID pesca per sedia; con 1 trade/giorno e' la stessa legge del bootstrap dei blocchi
    d = oi['p'].get('PASS', 0) - ob['p'].get('PASS', 0)
    chk("(i) 1 trade/giorno: IID - blocchi = %+.2f punti (rumore +-0,5 su 20.000 sim; tolleranza 1,5)" % d,
        abs(d) < 1.5, "-> blocchi %.2f%%, IID %.2f%%, %d giornate" % (ob['p'].get('PASS', 0), oi['p'].get('PASS', 0), len(f1)))
    #    (i') la STESSA prova nella configurazione della tabella (blocchi SENZA reimmissione, IID con):
    #    qui la differenza non e' zero ed e' DISEGNO, non correlazione. Si stampa, non si giudica.
    ob = simula_v2(f1, 2.0, S_OGGI, **KW_CAMPO)
    oi = simula_v2(f1, 2.0, S_OGGI, comp=comp_iid(pools1, conta1), **KW_CAMPO)
    print("       (i') informativo, configurazione della tabella (blocchi SENZA reimmissione): blocchi %.2f%%, IID %.2f%% -> "
          "IID - blocchi = %+.2f punti di solo DISEGNO (semi 12/13: -1,00 / -0,72)" % (
              ob['p'].get('PASS', 0), oi['p'].get('PASS', 0), oi['p'].get('PASS', 0) - ob['p'].get('PASS', 0)))
    # 8. CONTRO-ESEMPIO (ii): correlazione artificiale 1 -> P(fermata) blocchi > IID
    #    per ogni sedia i giornalieri ordinati dal peggiore; giornata j = j-esimo peggiore di OGNI sedia
    ordinati = dict((n, sorted(dati[n]['giorni'].values())) for n in V1)
    N2 = max(len(v) for v in ordinati.values())
    cal2 = ['2030.%02d.%02d' % (1 + j // 28, 1 + j % 28) for j in range(N2)]
    finto3 = dict((n, dict(dati[n], giorni=dict((cal2[j], v) for j, v in enumerate(ordinati[n])),
                           posizioni=[(cal2[j], v) for j, v in enumerate(ordinati[n])])) for n in V1)
    #    La misura giusta e' il MURO GIORNALIERO col Guardian SPENTO: una giornata oltre il 5% richiede
    #    piu' sedie in perdita INSIEME, e la copula comonotona (correlazione 1) la rende massima.
    #    Col Guardian ACCESO il taglio B1 a 4,5% rende le perdite concentrate PIU' ECONOMICHE in totale
    #    (oltre il taglio non si perde), e le due forze si oppongono: si stampa, non si giudica.
    f2, a2 = blocchi(finto3, V1, cal2, 2.0)
    p2, c2 = pool_posizioni(finto3, V1, cal2, 2.0)
    kw_off = dict(guardian=None, g_tot=None, min_giorni=MIN_GIORNI)
    ob = simula_v2(f2, 2.0, S_OGGI, attivo=a2, **kw_off)
    oi = simula_v2(f2, 2.0, S_OGGI, attivo=a2, comp=comp_iid(p2, c2), **kw_off)
    mb, mi = ob['p'].get('MORTE_GIORNALIERA', 0), oi['p'].get('MORTE_GIORNALIERA', 0)
    chk("(ii) correlazione 1, Guardian SPENTO: P(muro giornaliero 5%%) blocchi %.1f%% > IID %.1f%%" % (mb, mi), mb > mi + 1.0)
    ob = simula_v2(f2, 2.0, S_OGGI, attivo=a2, **KW_CAMPO)
    oi = simula_v2(f2, 2.0, S_OGGI, attivo=a2, comp=comp_iid(p2, c2), **KW_CAMPO)
    print("       (ii) informativo, Guardian ACCESO: P(fermata 9,3) blocchi %.1f%% / IID %.1f%%; PASS %.1f%% / %.1f%% "
          "(differenza entro il rumore, semi 12-14: -0,6/-0,2/-0,2; il taglio B1 del MODELLO e' perfetto sul realizzato "
          "e assorbe la coda: proprieta' del modello, magnitudo in campo [NON MISURATA])" % (
              ob['p'].get('FERMATA_GUARDIAN', 0), oi['p'].get('FERMATA_GUARDIAN', 0), ob['p'].get('PASS', 0), oi['p'].get('PASS', 0)))
    #    (iv) CONTRO-ESEMPIO della decomposizione: UNA sedia sola (771531, finestra A), tutto CON reimmissione.
    #    Fra sedie non c'e' niente da distruggere: IID-S deve coincidere coi blocchi. L'IID per posizione
    #    invece spezza le sue giornate a piu' posizioni: se se ne allontana, e' quello che misura.
    fE, aE = blocchi(dati, ['771531 EMA200'], calA, 2.0)
    pE, cE = pool_posizioni(dati, ['771531 EMA200'], calA, 2.0)
    kw_r = dict(KW_CAMPO, reimmissione=True, attivo=aE)
    obE = simula_v2(fE, 2.0, S_OGGI, **kw_r)
    osE = simula_v2(fE, 2.0, S_OGGI, comp=comp_sedia_giorno(dati, ['771531 EMA200'], calA, 2.0), **kw_r)
    oiE = simula_v2(fE, 2.0, S_OGGI, comp=comp_iid(pE, cE), **kw_r)
    bE, sE, iE = obE['p'].get('PASS', 0), osE['p'].get('PASS', 0), oiE['p'].get('PASS', 0)
    chk("(iv) 771531 sola: IID-S - blocchi = %+.2f punti (tolleranza 1,5: niente da distruggere fra sedie)" % (sE - bE),
        abs(sE - bE) < 1.5, "-> blocchi %.2f%%, IID-S %.2f%%" % (bE, sE))
    chk("(iv) 771531 sola: IID per posizione - blocchi = %+.2f punti (> 5: misura il co-movimento DENTRO la sedia)" % (iE - bE),
        iE - bE > 5.0, "-> IID per posizione %.2f%%" % iE)
    # 9. IID sui dati veri: il conteggio delle posizioni per giornata torna
    pA, cA = pool_posizioni(dati, V1, calA, 2.0)
    chk("IID: posizioni nel pool == posizioni contate sul calendario A (%d)" % sum(len(v) for v in pA.values()),
        sum(len(v) for v in pA.values()) == sum(sum(c.values()) for c in cA))
    # 10. stato del conto (dalla v1)
    chk("stato: saldo 75.090,72, DD 6,14%%, giorni ancora da fare %d, Guardian 4,5/9,3" % MIN_GIORNI,
        abs(SALDO_OGGI - 75090.72) < 0.005 and MIN_GIORNI == 1 and G_GIORN == 0.045 and G_TOT == 0.093)
    ok = autotest_r255(chk, dati, S, fixture_dir) and ok
    print("AUTOTEST: %s" % ("TUTTO VERDE" if ok else "ROSSO"))
    return ok


# ---------------------------------------------------------------- autotest della 770212 (fixture R255 finta)
R246_PT = os.path.join(QUI, 'risultati_archivio', 'R246', 'PERTRADE', 'abtg_trades_%s_%s_%d.csv')


def fixture_dir_default():
    cand = os.environ.get('CLAUDE_SCRATCHPAD')
    return os.path.join(cand if cand and os.path.isdir(cand) else tempfile.gettempdir(), 'mc_r255')


def fixture_r255(dest, variante='pulito', data_meno5=None):
    """Raccolta R255 FINTA nel formato vero (PERTRADE/abtg_trades_..._793101.csv e _793102.csv, cartelle ROUND_R255a/b
       vuote per trova_raccolta), costruita dagli archivi VERI R246 794603 (IS) + 794601 (OOS), long a 100.000 / 1%:
       short = segno INVERTITO, net e lotti / 10 (100.000 -> 10.000 alla stessa misura 1%), deal_type 0, stesse date;
       file 15:30 = +1 ora e net x0,9 (cosi' le tre curve sono DIVERSE e la selezione per calendario si misura).
       varianti: 'pulito' | 'zero' (tutti i net a 0) | 'meno5' (la posizione del giorno data_meno5 vale -500,00 =
       -5% di 10.000; il resto invariato). Ritorna (base, d14, d15) con i deal scritti."""
    a603 = lr.leggi_pertrade(R246_PT % (lr.EA, lr.SIMB, 794603))
    a601 = lr.leggi_pertrade(R246_PT % (lr.EA, lr.SIMB, 794601))
    assert len(a603) == 74 and len(a601) == 130, (len(a603), len(a601))
    base = os.path.join(dest, 'ROUND_R255_SHORT_DOW_INFASE_mc_' + variante)
    if os.path.isdir(base):
        shutil.rmtree(base)
    for sub in ('PERTRADE', 'ROUND_R255a', 'ROUND_R255b'):
        os.makedirs(os.path.join(base, sub))
    d14 = []
    for src, off in ((a603, 0), (a601, 1000)):
        for d in src:
            d14.append(dict(t=d['t'], pid=d['pid'] + off, type=0, vol=round(d['vol'] / 10.0, 2), price=d['price'],
                            net=round(-d['net'] / 10.0, 2)))
    if variante == 'zero':
        for d in d14:
            d['net'] = 0.0
    elif variante == 'meno5':
        pid = [d['pid'] for d in d14 if d['t'].strftime('%Y.%m.%d') == data_meno5]
        assert pid, data_meno5
        primo = True
        for d in d14:
            if d['pid'] == pid[0]:
                d['net'] = -500.0 if primo else 0.0; primo = False
    d15 = [dict(d, t=d['t'] + dt.timedelta(hours=1), net=round(d['net'] * 0.9, 2)) for d in d14]
    lr._scrivi_pt(os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (lr.EA, lr.SIMB, lr.FILE['R255a']['g1'])), lr.FILE['R255a']['g1'], d14)
    lr._scrivi_pt(os.path.join(base, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (lr.EA, lr.SIMB, lr.FILE['R255b']['g1'])), lr.FILE['R255b']['g1'], d15)
    return base, d14, d15


def inverno_ue_a_mano(d):
    """CONTRO-ESEMPIO: le finestre UE solari scritte per esteso qui (docs/OROLOGIO: ultima domenica di ottobre ->
       ultima domenica di marzo), senza passare da leggi_r255.INV_UE."""
    return (dt.date(2024, 10, 27) <= d < dt.date(2025, 3, 30)) or (dt.date(2025, 10, 26) <= d < dt.date(2026, 3, 29))


def autotest_r255(chk, dati_v2, S, fixture_dir):
    ok = [True]

    def c(nome, cond, dettaglio=''):
        chk(nome, cond, dettaglio); ok[0] = ok[0] and bool(cond)
    print("AUTOTEST 770212 da --r255 (fixture in %s)" % fixture_dir)
    calA, calB = S['calA'], S['calB']
    # 0. la firma letta dal preset, con le righe
    pr = leggi_preset_770212()
    c("preset 770212: InpSessionHour=16 (r.%d) InpSessionMin=30 (r.%d) InpRiskPercent=2.00 (r.%d) InpMagic=770212 (r.%d) short-only" % (
        pr['InpSessionHour'][1], pr['InpSessionMin'][1], pr['InpRiskPercent'][1], pr['InpMagic'][1]),
        pr['InpSessionHour'][0] == '16' and pr['InpSessionMin'][0] == '30' and float(pr['InpRiskPercent'][0]) == 2.0
        and pr['InpMagic'][0] == '770212' and pr['InpAllowShort'][0] == 'true' and pr['InpAllowLong'][0] == 'false')
    cv, _ = curva_dal_preset(pr)
    c("curva dal preset: ora fissa 16:30 FTMO -> FTMO-DOC", cv == 'FTMO-DOC', "-> %s" % cv)
    c("misura del per-trade R255a: InpRiskPercent=1.0 (r.%d)" % rischio_misura_r255()[1], rischio_misura_r255()[0] == 1.0)
    falso = dict(pr); falso['InpSessionHour'] = ('14', 0)
    try:
        curva_dal_preset(falso); rif = False
    except SystemExit:
        rif = True
    c("contro-esempio: preset a 14:30 -> RIFIUTATO (nessuna mappa: [NON MODELLATA], non un'altra curva zitta)", rif)
    # 1. fixture pulita: le tre curve, e la FTMO-DOC rifatta A MANO dai deal scritti
    base, d14, d15 = fixture_r255(fixture_dir, 'pulito')
    r = carica_r255(base, verifica=False)   # fixture SINTETICA senza CSV: il cancello si prova sotto, in (e)
    c("fixture: raccolta trovata, curva scelta %s, senza scelta manuale" % r['scelta'], r['scelta'] == 'FTMO-DOC' and not r['manuale'])
    cf, cc, ci = r['curve']['FTMO-DOC'], r['curve']['CONTROLLO'], r['curve']['IN FASE']
    c("fixture: 152 posizioni per curva (56 IS + 96 OOS degli archivi), moncone 0", all(len(x['posizioni']) == 152 and x['moncone'] == 0 for x in (cf, cc, ci)),
      "-> %d / %d / %d" % (len(cf['posizioni']), len(cc['posizioni']), len(ci['posizioni'])))
    mano = sum(d['net'] for d in d14 if not inverno_ue_a_mano(d['t'].date())) + sum(d['net'] for d in d15 if inverno_ue_a_mano(d['t'].date()))
    c("FTMO-DOC a mano = 14:30 fuori dall'inverno UE + 15:30 dentro (%.2f) == curva caricata (%.2f)" % (mano, sum(cf['giorni'].values())),
      abs(mano - sum(cf['giorni'].values())) < 1e-6)
    c("CONTROLLO == tutto il file 14:30 (%.2f)" % sum(d['net'] for d in d14), abs(sum(cc['giorni'].values()) - sum(d['net'] for d in d14)) < 1e-6)
    c("le tre curve sono DIVERSE fra loro (il file 15:30 vale x0,9): FTMO-DOC %.2f / IN FASE %.2f / CONTROLLO %.2f" % (
        sum(cf['giorni'].values()), sum(ci['giorni'].values()), sum(cc['giorni'].values())),
      len(set(round(sum(x['giorni'].values()), 2) for x in (cf, cc, ci))) == 3)
    c("lato: tutti i deal del per-trade sono chiusure BUY (deal_type 0)", all(d['type'] == 0 for d in r['deals']['R255a'] + r['deals']['R255b']))
    # (a) senza --r255 non c'e' nessuna 770212 nei dati e la tabella non la conosce
    c("(a) carica_v2() senza --r255 non contiene la 770212 (stesse %d sedie di oggi)" % len(SORGENTI_V2),
      N_770212 not in dati_v2 and not any(k in dati_v2 for k in SENS_770212.values()) and len(dati_v2) == len(SORGENTI_V2))
    dati = aggiungi_770212(dict(dati_v2), r)
    c("(a) ... e con --r255 le 4 sedie v1 restano bit per bit uguali (blocchi A == pool_feriali v1)",
      blocchi(dati, V1, calA, 2.0) == S['G0_fer'])
    # (d) date fuori finestra: le 56 posizioni dell'era IS (2024.09.30 -> 2025.06.05) stanno FUORI da A e da B
    inA, fuA, pA, uA = fuori_finestra(cf['posizioni'], calA)
    inB, fuB, pB, uB = fuori_finestra(cf['posizioni'], calB)
    n_is = sum(1 for d, _ in cf['posizioni'] if d < '2025.06.10')
    n_pre_b = sum(1 for d, _ in cf['posizioni'] if d < calB[0])
    c("(d) finestra A: %d dentro, %d FUORI (%s -> %s) == 56 posizioni IS dell'archivio 794603" % (inA, fuA, pA, uA), fuA == 56 == n_is and inA == 96)
    c("(d) finestra B: %d dentro, %d FUORI == IS + le OOS prima del %s (%d)" % (inB, fuB, calB[0], n_pre_b), fuB == n_pre_b and inB + fuB == 152)
    f6, a6 = blocchi(dati, V1 + ['770105 DAXshort', N_770212], calB, 2.0)
    f5, a5 = blocchi(dati, V1 + ['770105 DAXshort'], calB, 2.0)
    dentro = sum(x for d, x in cf['posizioni'] if calB[0] <= d <= calB[-1]) / lr.DEPOSITO
    c("(d) blocchi B con 770212 - senza = solo le posizioni DENTRO la finestra (%.6f)" % dentro, abs((sum(f6) - sum(f5)) - dentro) < 1e-9,
      "-> %.9f" % (sum(f6) - sum(f5)))
    c("(d) il calendario NON si allarga: B resta %s -> %s, %d giorni" % (calB[0], calB[-1], len(calB)), calB[0] == '2025.07.01' and len(calB) == 262)
    # (b) per-trade tutto a zero: P(PASS) invariata al decimale, pool bit per bit uguale
    base0, _, _ = fixture_r255(fixture_dir, 'zero')
    r0 = carica_r255(base0, verifica=False)
    dati0 = aggiungi_770212(dict(dati_v2), r0)
    f0, a0 = blocchi(dati0, V1 + ['770105 DAXshort', N_770212], calB, 2.0)
    c("(b) 770212 a zero: pool B bit per bit == senza 770212 (attivo puo' cambiare: %d giornate in piu' 'operate')" % (sum(a0) - sum(a5)), f0 == f5)
    o0 = corsa(f0, 2.0, attivo=a0); o5 = corsa(f5, 2.0, attivo=a5)
    c("(b) 770212 a zero: P(PASS) %.2f%% contro %.2f%% -> differenza %+.3f punti (< 0,05: invariata al decimale)" % (
        o0['p'].get('PASS', 0), o5['p'].get('PASS', 0), o0['p'].get('PASS', 0) - o5['p'].get('PASS', 0)),
      abs(o0['p'].get('PASS', 0) - o5['p'].get('PASS', 0)) < 0.05)
    # (c) una perdita di -5% in un giorno (-500 su 10.000): stessa giornata = stesso blocco -> la regola 4,5 la vede
    #     giorno scelto: il primo di B in cui la fixture ha una posizione e le altre 5 sedie NON perdono
    idx = dict((d, i) for i, d in enumerate(calB))
    giorno = next(d for d, _ in cf['posizioni'] if d in idx and f5[idx[d]] >= 0)
    base5, _, _ = fixture_r255(fixture_dir, 'meno5', data_meno5=giorno)
    r5 = carica_r255(base5, verifica=False)
    dati5 = aggiungi_770212(dict(dati_v2), r5)
    fm, am = blocchi(dati5, V1 + ['770105 DAXshort', N_770212], calB, 2.0)
    k = idx[giorno]
    c("(c) giornata %s: blocco con 770212 (%.6f) == blocco senza (%.6f) + (-500/10.000)" % (giorno, fm[k], f5[k]), fm[k] == f5[k] + (-500.0 / 10000.0))
    o_con = simula_v2([fm[k]], 2.0, S_OGGI, attivo=[True], n_sim=2000, **KW_CAMPO)
    o_sen = simula_v2([f5[k]], 2.0, S_OGGI, attivo=[True], n_sim=2000, **KW_CAMPO)
    c("(c) pool di quella sola giornata a taglia 2,00%%: CON 770212 -> FERMATA_GUARDIAN %.0f%% (il taglio 4,5 la vede: -5%% x 2 = -10%% > 4,5); "
      "SENZA -> FERMATA %.0f%%" % (o_con['p'].get('FERMATA_GUARDIAN', 0), o_sen['p'].get('FERMATA_GUARDIAN', 0)),
      o_con['p'].get('FERMATA_GUARDIAN', 0) == 100.0 and o_sen['p'].get('FERMATA_GUARDIAN', 0) == 0.0)
    o_off = simula_v2([fm[k]], 2.0, S_OGGI, attivo=[True], n_sim=2000, guardian=None, g_tot=None, min_giorni=MIN_GIORNI)
    c("(c) stessa giornata, Guardian SPENTO: MORTE_GIORNALIERA %.0f%% (muro FTMO 5%% del banco)" % o_off['p'].get('MORTE_GIORNALIERA', 0),
      o_off['p'].get('MORTE_GIORNALIERA', 0) == 100.0)
    pp, cc_ = pool_posizioni(dati5, V1 + ['770105 DAXshort', N_770212], calB, 2.0)
    o_iid = simula_v2([fm[k]], 2.0, S_OGGI, attivo=[True], n_sim=2000, comp=comp_iid(pp, cc_), **KW_CAMPO)
    print("       (c) informativo: la stessa giornata nell'IID per posizione (la -500 pescata a caso dal pool 770212): FERMATA %.1f%% "
          "-- e' quello che l'IID distrugge" % o_iid['p'].get('FERMATA_GUARDIAN', 0))
    # 4. CONTRO-ESEMPIO DELLA SCALA, rifatto a mano su UNA operazione: P/L a 10.000 e lotto del per-trade -> EUR sul conto
    #    FTMO al rischio del preset (2,00% del saldo 75.090,72, ingresso->SL) = net x lotto_FTMO / lotto_pertrade
    pos = min((p for p in cf['pos_lr'] if calB[0] <= p['data'].strftime('%Y.%m.%d') <= calB[-1]), key=lambda p: p['net'])   # lo stop peggiore
    net, lotto = pos['net'], pos['vol']
    rischio_ftmo = SALDO_OGGI * float(pr['InpRiskPercent'][0]) / 100.0          # 1.501,81 EUR
    rischio_mis = lr.DEPOSITO * r['rmis'][0] / 100.0                              # 100,00 EUR
    lotto_ftmo = lotto * rischio_ftmo / rischio_mis
    eur_mano = round(net * lotto_ftmo / lotto, 2)
    eur_mod = round(net * scala(N_770212, dati, 2.0, 0.0) * 2.0 * SALDO_OGGI, 2)
    c("scala a mano: posizione %s net %.2f (10.000, 1%%), lotto %.2f -> rischio FTMO %.2f EUR (2,00%% di %.2f), lotto FTMO %.4f "
      "-> %.2f EUR a mano == %.2f EUR nel modello (net/10.000 x 2,0 x saldo)" % (
          pos['data'], net, lotto, rischio_ftmo, SALDO_OGGI, lotto_ftmo, eur_mano, eur_mod), eur_mano == eur_mod and abs(rischio_ftmo - 1501.81) < 0.005)
    eur_321 = round(net * (rischio_ftmo / (pos['B_corsa'] * r['rmis'][0] / 100.0)), 2)
    print("       classe 321: quella posizione fu dimensionata sul saldo di corsa %.2f, non su 10.000: a mano %.2f EUR contro %.2f "
          "(%+.2f EUR, %+.1f%%) -- DICHIARATO, non corretto (come oro e sedie v1)" % (pos['B_corsa'], eur_321, eur_mano, eur_321 - eur_mano,
                                                                                    100.0 * (eur_321 / eur_mano - 1.0)))
    # 5. le righe della tabella con la 770212 esistono e hanno nomi diversi da quelle di oggi
    R = righe_770212(dati, r, calA, calB, 2.0)
    c("righe 770212: %d righe aggiunte, nomi tutti distinti, con le 2 sensibilita'" % len(R),
      len(R) == 14 and len(set(n for n, *_ in R)) == 14 and sum(1 for n, *_ in R if 'sensibilita' in n) == 2)
    c("scelta manuale: --r255-curva CONTROLLO viene etichettata", carica_r255(base, 'CONTROLLO', verifica=False)['manuale'] is True)
    # (e) CANCELLO del lettore (classe 890), nei due sensi, sulle raccolte COMPLETE di leggi_r255.genera_fixture
    def rifiuta(fn):
        try:
            fn(); return None
        except SystemExit as e:
            return str(e)
    m_ = rifiuta(lambda: carica_r255(base))
    c("(e) fixture sintetica SENZA CSV _OOS con verifica=True (main) -> RIFIUTATA (E0: per leggi_r255 e' NULLA)",
      m_ is not None and 'E0' in m_, "-> %s" % (m_ or 'ACCETTATA')[:160])
    a603 = lr.leggi_pertrade(R246_PT % (lr.EA, lr.SIMB, 794603)); a601 = lr.leggi_pertrade(R246_PT % (lr.EA, lr.SIMB, 794601))
    bl = lr.genera_fixture(fixture_dir, 'mc_gate', a603, a601)
    rg = rifiuta(lambda: carica_r255(bl))
    c("(e) raccolta COMPLETA e sana (leggi_r255.genera_fixture 'pulito') -> ACCETTATA, pre-lettura senza NULLI", rg is None, "-> %s" % (rg or 'ok')[:160])
    po = os.path.join(bl, 'ROUND_R255a', '%s_%s_OOS_R255a.csv' % (lr.EA, lr.SIMB))
    with open(po) as fh:
        rows = fh.read().splitlines()
    hdr = rows[0].split(',')
    for i in (1, 2):
        v = rows[i].split(','); v[hdr.index('InpSessionHour')] = '15'; rows[i] = ','.join(v)
    with open(po, 'w') as fh:
        fh.write('\n'.join(rows) + '\n')
    m_ = rifiuta(lambda: carica_r255(bl))
    c("(e) R255a girato a InpSessionHour=15 (P0 NULLO per leggi_r255) -> RIFIUTATA", m_ is not None and 'P0' in m_, "-> %s" % (m_ or 'ACCETTATA')[:160])
    bl = lr.genera_fixture(fixture_dir, 'mc_gate', a603, a601)
    rp = os.path.join(bl, 'RIEPILOGO_R255.txt')
    with open(rp) as fh:
        t_ = [ln.replace('file NON nullo', 'FILE NULLO: MOTORE DIVERSO DAL PIN') if ln.startswith('R255b ') else ln for ln in fh.read().splitlines()]
    with open(rp, 'w') as fh:
        fh.write('\n'.join(t_) + '\n')
    m_ = rifiuta(lambda: carica_r255(bl))
    c("(e) la RIGA dice R255b NULLO (motore diverso dal pin) -> FTMO-DOC RIFIUTATA, CONTROLLO proposto come SCELTA MANUALE",
      m_ is not None and 'MOTORE DIVERSO' in m_ and 'SCELTA MANUALE' in m_, "-> %s" % (m_ or 'ACCETTATA')[:160])
    rm = carica_r255(bl, 'CONTROLLO')
    c("(e) ... e con --r255-curva CONTROLLO si modella il solo 14:30, etichettato manuale, con il NULLO di R255b in chiaro",
      rm['manuale'] and rm['curve']['FTMO-DOC'] is None and 'R255b' in rm['nulli_lr'])
    # (f) la LETTERA del preset, tutta: un preset con un'altra gestione dell'uscita, o un'altra taglia, NON si modella zitto
    c("(f) preset in firma == prova R255a salvo ora/magic/rischio: 0 differenze", confronta_preset_prova() == [], "-> %s" % confronta_preset_prova())
    pf = os.path.join(fixture_dir, 'preset_770212_tp15.set')
    with open(PRESET_770212, encoding='utf-8', errors='replace') as fh:
        testo = fh.read()
    with open(pf, 'w', encoding='utf-8') as fh:
        fh.write(testo.replace('InpTP1_R=1.0', 'InpTP1_R=1.5').replace('InpCloseHour=19', 'InpCloseHour=20'))
    dd_ = confronta_preset_prova(pf)
    c("(f) preset con InpTP1_R=1.5 e chiusura 20:30 -> 2 differenze (TP1 e durata della seduta)",
      len(dd_) == 2 and any('InpTP1_R' in x for x in dd_) and any('durata' in x for x in dd_), "-> %s" % dd_)
    pr1 = os.path.join(fixture_dir, 'preset_770212_rischio1.set')
    with open(pr1, 'w', encoding='utf-8') as fh:
        fh.write(testo.replace('InpRiskPercent=2.00', 'InpRiskPercent=1.00'))
    m_ = rifiuta(lambda: carica_r255(base, verifica=False, preset_path=pr1))
    c("(f) preset con InpRiskPercent=1.00 -> RIFIUTATO (la scala e' scritta per 2,00 = taglia indici in campo)",
      m_ is not None and 'InpRiskPercent=1.00' in m_, "-> %s" % (m_ or 'ACCETTATO')[:120])
    c("(f) frase del verbo: banda che attraversa lo zero -> 'NON si distingue'; tutta positiva -> 'aggiunge'; senza banda -> dichiarato",
      frase_delta(0.6, [-0.2, 0.4, 0.1]).startswith('NON si distingue') and frase_delta(0.6, [0.6, 1.1, 0.9]).startswith('aggiunge')
      and 'banda NON calcolata' in frase_delta(0.6, None))
    print("AUTOTEST 770212: %s" % ("TUTTO VERDE" if ok[0] else "ROSSO"))
    return ok[0]


# ---------------------------------------------------------------- main
def main(r255=None):
    dati = carica_v2()
    if r255:
        aggiungi_770212(dati, r255)
    S = scenari(dati)
    calA, calB, calO = S['calA'], S['calB'], S['calORO']
    base, _ = S['G0_pool']; fer_pool, fer_att = S['G0_fer']
    print("=" * 120)
    print("MC CHALLENGE FTMO 541452707 v2 -- BLOCCHI PER GIORNATA + 770105 + ORO LONG -- dallo stato del 26/09/2026")
    print("saldo %.2f = %.6f del 80.000 | DD %.2f%% | target 88.000 | giorni fatti %d, ne manca %d | Guardian 4,5 / 9,3 / pausa 3,5 / cap 4,00" % (
        SALDO_OGGI, S_OGGI, 100 * (1 - S_OGGI), st.GIORNI_FATTI, MIN_GIORNI))
    print("seme %d, %d simulazioni per riga; banda = semi %s" % (SEME, NSIM, SEMI_BANDA))
    print("finestra A (4 sedie v1): %s -> %s, %d giorni di borsa | finestra B (con 770105): %s -> %s, %d giorni | oro intera storia: %s -> %s, %d giorni" % (
        calA[0], calA[-1], len(calA), calB[0], calB[-1], len(calB), calO[0], calO[-1], len(calO)))
    for n in SORGENTI_V2:
        s = dati[n]
        inA = sum(1 for d in calA if d in s['giorni']); inB = sum(1 for d in calB if d in s['giorni'])
        print("  %-16s %3d posizioni, %3d giornate (%s -> %s) | in A: %3d | in B: %3d | dep %.0f rischio %.1f%% | %s" % (
            n, len(s['posizioni']), len(s['giorni']), min(s['giorni']), max(s['giorni']), inA, inB, s['dep'], s['rmis'],
            'segue la taglia indici' if s['segue'] else 'taglia ASSOLUTA (0,5 / 1,0)'))
    if r255:
        pr = r255['preset']
        print("  %-16s MODELLATA da --r255 %s%s" % (N_770212, r255['base'], (' (%s)' % r255['nota']) if r255['nota'] else ''))
        print("    dal preset in firma (%s): InpMagic=%s (r.%d) | InpAllowShort=%s (r.%d) InpAllowLong=%s (r.%d) | "
              "InpRiskPercent=%s (r.%d) | InpSessionHour=%s (r.%d) InpSessionMin=%s (r.%d)" % (
                  os.path.relpath(PRESET_770212, os.path.join(QUI, '..')), pr['InpMagic'][0], pr['InpMagic'][1],
                  pr['InpAllowShort'][0], pr['InpAllowShort'][1], pr['InpAllowLong'][0], pr['InpAllowLong'][1],
                  pr['InpRiskPercent'][0], pr['InpRiskPercent'][1], pr['InpSessionHour'][0], pr['InpSessionHour'][1],
                  pr['InpSessionMin'][0], pr['InpSessionMin'][1]))
        if r255['manuale'] and r255['scelta'] != r255['auto']:
            print("    curva scelta: %s [SCELTA MANUALE --r255-curva, NON quella del preset] -- il preset detta %s: %s" % (
                r255['scelta'], r255['auto'], r255['perche']))
        else:
            print("    curva scelta: %s %s-- %s" % (r255['scelta'], '[SCELTA MANUALE --r255-curva] ' if r255['manuale'] else '', r255['perche']))
        print("    preset == prova R255a input per input, salvo ora/chiusura (stesso scarto), magic, rischio e 2 stringhe spente "
              "(confronta_preset_prova: 0 differenze)")
        print("    pre-lettura di leggi_r255 (E0/P0/G1/C0/L0/S1 + NULLI della riga): %s" % (
            'ESEGUITA, R255a e R255b non NULLI' if not r255['nulli_lr'] else
            'ESEGUITA, NULLI: ' + ' || '.join('%s: %s' % (f, ' | '.join(v)[:200]) for f, v in r255['nulli_lr'].items())))
        for a_ in r255['avvisi']:
            print("    ATTENZIONE: %s" % a_)
        print("    [DERIVATO dal regolamento FTMO, NON MISURATO sul feed FTMO]: la mappa 16:30 FTMO -> 14:30/15:30 BCM per calendario UE; "
              "e la griglia H4 di FTMO e' DIVERSA da quella BCM (testa R255a par. 6): il filtro EMA H4 del preset su FTMO legge "
              "altre candele [NON MISURATO]")
        print("    [classe 800, NON corretto] i lotti del Dow a 10.000 sono piccoli (passo 0,1: fino a ~10-40%% di arrotondamento sul "
              "singolo lotto, testa R255a par. 7; errore sul DD e_eff >= %.4f): la scala net/10.000 lo porta intero sul conto FTMO, "
              "dove il lotto a 2,00%% e' ~15 volte piu' grande e quasi senza arrotondamento" % lr.E_MIN)
        print("    misura del per-trade: deposito %.0f, InpRiskPercent=%.1f (prova R255a r.%d), rischio ingresso->SL (InpRiskMode=0); "
              "scala = net / %.0f x fattore (a fattore 2,0 = %s%% del preset)" % (
                  lr.DEPOSITO, r255['rmis'][0], r255['rmis'][1], lr.DEPOSITO, pr['InpRiskPercent'][0]))
        for c in CURVE_770212:
            e = r255['curve'][c]
            if e is None:
                print("    %-10s NON COSTRUIBILE (manca il file 15:30)" % c); continue
            perd = sorted(x for _, x in e['posizioni'] if x < 0)
            med = perd[len(perd) // 2] if perd else 0.0
            inA, fuA, pfA, ufA = fuori_finestra(e['posizioni'], calA)
            inB, fuB, _, _ = fuori_finestra(e['posizioni'], calB)
            print("    %-10s %3d posizioni, %3d giornate (%s -> %s), somma %+.2f, perdita mediana %.2f (attesa ~-%.0f a 1%% di %.0f) | "
                  "in A: %3d, FUORI A: %3d (%s -> %s, IGNORATE) | in B: %3d, FUORI B: %3d | moncone 2024.09.26: %d | "
                  "saldo di corsa %.2f .. %.2f (classe 321: scarto max %.1f%%, DICHIARATO non corretto)" % (
                      c, len(e['posizioni']), len(e['giorni']), min(e['giorni']), max(e['giorni']), sum(e['giorni'].values()), med,
                      lr.DEPOSITO * r255['rmis'][0] / 100.0, lr.DEPOSITO, inA, fuA, pfA, ufA, inB, fuB, e['moncone'],
                      e['b_corsa'][0], e['b_corsa'][1], 100.0 * max(abs(b / lr.DEPOSITO - 1.0) for b in e['b_corsa'])))
    print("NON MODELLATE: " + " | ".join(n for n in NON_MODELLATE if not (r255 and n.startswith('770212'))))

    print("\n[CORRELAZIONE INTRA-GIORNATA, MISURATA sui per-trade]")
    corr = [('A: 4 sedie + oro', V1 + ['795301 ORO'], calA), ('B: 4 sedie + 770105 + oro', V1 + ['770105 DAXshort', '795301 ORO'], calB)]
    if r255:
        corr.append(('B: 4 sedie + 770105 + 770212 (%s) + oro' % r255['scelta'], V1 + ['770105 DAXshort', N_770212, '795301 ORO'], calB))
    for tag, nomi, cal in corr:
        neg2, op2, coppie = correlazione(dati, nomi, cal)
        print("  finestra %s: giornate con >=2 sedie operative %d, con >=2 sedie in PERDITA insieme %d" % (tag, op2, neg2))
        for a, b, nc, rho, ins in coppie:
            print("    %-16s x %-16s giorni comuni %3d  rho %s  perdono insieme %s" % (
                a, b, nc, '%+.2f' % rho if rho is not None else '  n/d', ins if ins is not None else 'n/d'))

    print("\n[DECOMPOSIZIONE DEL CO-MOVIMENTO, taglia 2,00%, TUTTO CON reimmissione (disegno neutro), semi 11/12/13]")
    print("  PASS / fine<=5gg.  BLK = blocchi | IID-S = solo FRA sedie distrutto | IID = anche DENTRO la sedia distrutto")
    deco = [('A: 4 sedie v1', V1, calA), ('B: 4 sedie + 770105', V1 + ['770105 DAXshort'], calB),
            ('A: 771531 sola (contro-esempio iv)', ['771531 EMA200'], calA)]
    if r255:
        deco.append(('B: 4 sedie + 770105 + 770212', V1 + ['770105 DAXshort', N_770212], calB))
    for tag, nomi, cal in deco:
        f, a = blocchi(dati, nomi, cal, 2.0)
        pp, cc = pool_posizioni(dati, nomi, cal, 2.0)
        cs = comp_sedia_giorno(dati, nomi, cal, 2.0)
        out = []
        for sm in (11, 12, 13):
            kw = dict(KW_CAMPO, reimmissione=True, attivo=a, seme=sm)
            r = [simula_v2(f, 2.0, S_OGGI, comp=c, **kw) for c in (None, cs, comp_iid(pp, cc))]
            out.append(" / ".join("%.1f-%.1f" % (o['p'].get('PASS', 0), fine5(o)) for o in r))
        print("  %-36s BLK / IID-S / IID  ->  %s" % (tag, "  ||  ".join(out)))

    righe_md = []
    for fatt, etich in [(2.0, "2,00% (taglia in campo)"),
                        (1.0, "1,00% [preset demo BCM, tetto PROPOSTO il 19/09 e NON firmato -- solo riferimento, NESSUNA PROPOSTA]"),
                        (0.65, "0,65% [taglia firmata di casa sul 100k e sul REALE -- solo riferimento, NESSUNA PROPOSTA]")]:
        banda_on = (fatt == 2.0)
        print("\n[TAGLIA INDICI %s]  oro sempre a taglia ASSOLUTA 0,5%% o 1,0%% del saldo" % etich)
        righe = []
        # G0
        righe.append(("G0  v1 com'e' (242 giornate con operazioni) [ANCORA 57,2 a 2%]", base, None, None, None, None))
        righe.append(("G0f v1 feriali (277 giorni di borsa, 35 a zero)", fer_pool, fer_att, None, None, None))
        # finestra A
        fA, aA = blocchi(dati, V1, calA, fatt)
        pA, cA = pool_posizioni(dati, V1, calA, fatt)
        righe.append(("IID A: 4 sedie, posizioni indipendenti (modello 'trade indipendenti')", fA, aA, comp_iid(pA, cA), None, None))
        righe.append(("IID-S A: 4 sedie, giornate di sedia indipendenti (solo FRA sedie)", fA, aA,
                      comp_sedia_giorno(dati, V1, calA, fatt), None, None))
        righe.append(("BLK A: 4 sedie a blocchi giornalieri (== G0f)", fA, aA, None, None, None))
        for t in (0.5, 1.0):
            f, a = blocchi(dati, V1 + ['795301 ORO'], calA, fatt, t)
            righe.append(("BLK A: 4 sedie + ORO %.1f%% (43 giornate oro, agganciate per data)" % t, f, a, None, None, None))
        p, c = pool_posizioni(dati, V1 + ['795301 ORO'], calA, fatt, 1.0)
        f, a = blocchi(dati, V1 + ['795301 ORO'], calA, fatt, 1.0)
        righe.append(("IID A: 4 sedie + ORO 1,0%, posizioni indipendenti", f, a, comp_iid(p, c), None, None))
        for t in (0.5, 1.0):
            don = {'ORO': pool_oro_intero(dati, fatt, t, calO)}
            righe.append(("BLK A + ORO %.1f%% INTERA STORIA 2020-26, INDIPENDENTE dagli indici" % t, fA, aA, None, ['ORO'] * len(fA), don))
        # finestra B
        fB, aB = blocchi(dati, V1, calB, fatt)
        righe.append(("BLK B: 4 sedie, finestra B (2025.07.01 -> 2026.06.29)", fB, aB, None, None, None))
        f5, a5 = blocchi(dati, V1 + ['770105 DAXshort'], calB, fatt)
        righe.append(("BLK B: 4 sedie + 770105 (DAX short, 181 giornate)", f5, a5, None, None, None))
        p5, c5 = pool_posizioni(dati, V1 + ['770105 DAXshort'], calB, fatt)
        righe.append(("IID B: 4 sedie + 770105, posizioni indipendenti", f5, a5, comp_iid(p5, c5), None, None))
        righe.append(("IID-S B: 4 sedie + 770105, giornate di sedia indipendenti (solo FRA sedie)", f5, a5,
                      comp_sedia_giorno(dati, V1 + ['770105 DAXshort'], calB, fatt), None, None))
        for t in (0.5, 1.0):
            f, a = blocchi(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, t)
            righe.append(("BLK B: 4 sedie + 770105 + ORO %.1f%%" % t, f, a, None, None, None))
        p, c = pool_posizioni(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, 1.0)
        f, a = blocchi(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, 1.0)
        righe.append(("IID B: 4 sedie + 770105 + ORO 1,0%, posizioni indipendenti", f, a, comp_iid(p, c), None, None))
        don = {'ORO': pool_oro_intero(dati, fatt, 1.0, calO)}
        righe.append(("BLK B + 770105 + ORO 1,0% INTERA STORIA, INDIPENDENTE", f5, a5, None, ['ORO'] * len(f5), don))
        righe.append(("BLK B: 4 sedie + 770105 + ORO 1,0%% + slittamento x%.3f" % SLIP, f, a, None, None, 'slip'))
        if r255:
            righe += righe_770212(dati, r255, calA, calB, fatt)
        ris = collections.OrderedDict()
        for nome, pool, att, comp, sost, don in righe:
            slip = SLIP if don == 'slip' else 1.0
            if don == 'slip':
                sost, don = None, None
            o = corsa(pool, fatt, attivo=att, comp=comp, sost=sost, donatori=don, slip=slip)
            banda = None
            if banda_on:
                banda = [corsa(pool, fatt, attivo=att, comp=comp, sost=sost, donatori=don, slip=slip, seme=sm) for sm in SEMI_BANDA]
            s = riga_tab(nome, o, banda)
            righe_md.append((fatt, nome, o, banda))
            ris[nome] = (o, banda)
        if r255:
            stampa_delta_770212(ris, r255)
    print("=" * 120)
    return righe_md


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='MC challenge FTMO v2 (blocchi + 770105 + oro; 770212 solo con --r255)')
    ap.add_argument('--autotest', action='store_true', help='controlli e contro-esempi (compresa la fixture R255 finta), poi esce')
    ap.add_argument('--r255', default=None, metavar='CARTELLA', help='raccolta ROUND_R255_SHORT_DOW_INFASE_<data> (o la cartella che la contiene): modella la 770212')
    ap.add_argument('--r255-curva', default=None, choices=list(CURVE_770212), help='SCELTA MANUALE della curva (default: quella dettata dal preset in firma)')
    ap.add_argument('--fixture-dir', default=None, help='dove --autotest scrive la raccolta finta (default: $CLAUDE_SCRATCHPAD/mc_r255 o la temp)')
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest(a.fixture_dir) else 1)
    main(carica_r255(a.r255, a.r255_curva) if a.r255 else None)
