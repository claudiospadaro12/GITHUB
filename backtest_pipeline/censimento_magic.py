#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MARCATORE_CENSIMENTO_MAGIC_v2

La tabella `magic -> EA -> nostro/mercato`, prerequisito della classe 1530
(05/11/2026): senza di essa sono esposti il netto della flotta, il censimento
delle compresenze e il CRITERIO DI USCITA del 18/08, che decide per FAMIGLIA
chi si spegne.

v2 (06/11/2026) dopo il cancello: classi 1531-1538.

SORGENTI, nessuna inventata:
  (A) TUTTI i log dei preset ricostruiti dai .chr dal runner notturno (sola
      lettura): backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_*.log
      -> `magic -> nome del programma EA`. v1 leggeva solo l'ULTIMO log e
      buttava 55 notti di prove (classe 1535): leggerli tutti ha chiuso un
      DA CONFERMARE (`28081965` = `Gold Candle Bot`) e dato 8 conferme
      indipendenti, zero contraddizioni.
  (B) data/statements/trades_auto.csv -> `magic -> commento, n, netto, simboli`.

REGOLA DI CLASSIFICAZIONE, nell'ordine EFFETTIVO del codice -- e l'ordine E'
la regola (classe 1531: in v1 il docstring elencava un ordine diverso dal
codice, e i due divergevano proprio sul controesempio esibito come prova):
  0. MANUALE  se magic == 0. Non e' un EA: MT5 ci mette le operazioni a MANO.
     Era il PRIMO caso del codice e mancava da tutte e due le liste
     pubblicate della regola (classe 1532), pur spostando -19.667,88.
  1. NOSTRO   se (A) associa al magic un EA il cui nome inizia per ABTG_ o
     CLAU12_ -- il programma e' nostro per costruzione.
  2. MERCATO  se (A) associa un EA il cui nome NON e' ABTG_/CLAU12_.
     Controesempio reale: magic 250604 sta in un nostro .chr, ma l'EA e'
     `Gold_Ichimoku_TK_ATR_EA`: stare in un nostro grafico non rende nostro
     un EA. Dei 7 EA non nostri trovati nei .chr, solo questo ha un magic.
  3. MERCATO  se il commento porta un marchio di MARCHI_MERCATO.
  4. NOSTRO   se il commento porta un marchio di MARCHI_NOSTRI.
  5. DA CONFERMARE in tutti gli altri casi. NON si indovina: si stampa.

PROVENIENZA DELLE DUE LISTE, dichiarata giusta (classe 1531): sono scritte a
MANO dai commenti del CSV e dai preset (`EA_Comment=`). v1 dichiarava
"ricavato dai sorgenti in mql5/": FALSO, `BULGE_MULTI_SIGNAL_BLU`, `BULGE_V520`
e `EMA200 DOW` non esistono in nessun .mq5. Le due liste sono DISGIUNTE, e
l'autotest lo asserisce: in v1 `ICHICROSS` stava in tutte e due e la priorita'
la disinnescava per caso.

PERIMETRO: un solo conto, il piccolo 50503392 (`trades_auto.csv`). NON include
`trades_100k.csv` (100k 50504263), dove cinque nostri magic hanno altre 43
operazioni -- e `770611` arriva cosi' a n=20, la soglia MERITO del 18/08
(classe 1537). `n` e' additivo fra i conti; il NETTO no (lotto medio 0,591 sul
piccolo contro 7,356 sul 100k = 12,4x: sommarli sarebbe la classe 1526).

CHE COSA NON FA: non decide i DA CONFERMARE, non tocca niente sul campo, non
apre MT5, non va in rete. Legge due sorgenti e scrive un .md.
"""
import csv, re, io, glob, collections, sys, os

CSV = 'data/statements/trades_auto.csv'
CSV_100K = 'data/statements/trades_100k.csv'
LOGGLOB = 'backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_*.log'
USCITA = 'report/CENSIMENTO_MAGIC.md'

MARCHI_NOSTRI = [
 'BULGE_', 'DAX APERTURA', 'DAX LIVE', 'DAX M3', 'APERTURA MARCO',
 'NASDAQ APERTURA', 'NASDAQ LIVE', 'DOW APERTURA', 'MAXMIN', 'ORB ',
 'SUPERWAVE', 'SW DOW', 'STREV', 'EMA200', 'LARRY ', 'COST ',
 'GAPCONT', 'GAP ', 'EASYTREND', 'EZ ', 'PTE ', 'BB ', 'NIGHTLY',
 'LONDRA', 'FOMC POSTNEWS', 'ECB POSTNEWS', 'NFP POSTNEWS',
]
MARCHI_MERCATO = [
 'FINLABX', 'CF S [F]', 'CF B [F]', 'SNIPING', 'DARK VENUS', 'HEDGINGMARTINGALE',
 'NANG_KWAK', 'BASKET_', 'TIG BREAKOUT', 'APEX ORIGIN', 'MARCALBRECHTTRADING',
 'MP BY SPLPULSE', 'SSP SCALP', 'SSPV', 'SUPERSCALP PRO', 'XAUUSD 5 MINUTE',
 'GUNNER E', 'DRESEA', 'ICHICROSS', 'NASDAQMASTEREA', 'MAXOPPCATCHER',
 'NQ_V21', 'GZ BUY', 'GZ SELL', 'SAMPLE COMMENT', 'SELLSTOP', 'BUYSTOP',
 'NIGHT_BREAK_BOX',
]
NOSTRI_PREFISSI = ('ABTG_', 'CLAU12_')
ORDINE = {'NOSTRO': 0, 'DA CONFERMARE': 1, 'MERCATO': 2, 'MANUALE': 3}


def netto(r):
    return float(r['profit']) + float(r['commission']) + float(r['swap'])


def ea_dai_chr(testo):
    """magic -> {nomi EA}. Ritorna anche quante righe SEDIA sono state
    saltate perche' il magic non e' numerico: v1 le scartava in SILENZIO con
    una regex `(\\S+)` che perdeva ogni EA col nome contenente uno spazio
    (classe 1536 -- e uno era NOSTRO: `ABTG_ScalperDirezionale (4)`, magic
    779901, 93 occorrenze nei log)."""
    m = collections.defaultdict(set)
    viste = saltate = 0
    for g in re.finditer(r'--- SEDIA: (.+?)\s+su (\S+)\s+magic (\S+)\s+\[(\S+)\]', testo):
        ea, _sym, mg, _ch = g.groups()
        viste += 1
        if not mg.isdigit():
            saltate += 1
            continue
        m[mg].add(ea.strip())
    return m, viste, saltate


def classifica(mg, eas, commenti):
    """-> (classe, prova). L'ordine dei casi E' la regola, e questo ordine
    e' quello elencato nel docstring: sono lo stesso ordine (classe 1531)."""
    if mg == '0':
        return 'MANUALE', 'magic 0 = operazioni a mano, non un EA'
    nostri_ea = sorted(e for e in eas if e.upper().startswith(NOSTRI_PREFISSI))
    if nostri_ea:
        return 'NOSTRO', 'preset .chr: ' + ' / '.join(nostri_ea)
    altri_ea = sorted(e for e in eas if not e.upper().startswith(NOSTRI_PREFISSI))
    if altri_ea:
        return 'MERCATO', 'preset .chr, EA non nostro: ' + ' / '.join(altri_ea)
    su = [c.upper() for c in commenti if c.strip()]
    for marchio in MARCHI_MERCATO:
        if any(marchio in c for c in su):
            return 'MERCATO', 'commento di mercato: ' + marchio
    for marchio in MARCHI_NOSTRI:
        if any(c.startswith(marchio) for c in su):
            return 'NOSTRO', 'commento di casa: ' + marchio
    if not su:
        return 'DA CONFERMARE', 'commento VUOTO e magic non nei .chr'
    return 'DA CONFERMARE', 'commento non riconosciuto: ' + commenti[0][:30]


def leggi_csv(percorso):
    if not os.path.exists(percorso):
        return None
    return list(csv.DictReader(io.open(percorso, encoding='utf-8', errors='replace'), delimiter=';'))


def aggrega(righe):
    agg = collections.defaultdict(lambda: [0, 0.0, collections.Counter(), set(), 0.0])
    for r in righe:
        a = agg[r['magic']]
        a[0] += 1
        a[1] += netto(r)
        a[2][r['strategy'].strip()] += 1
        a[3].add(r['symbol'])
        a[4] += float(r['volume'])
    return agg


def autotest():
    """I sette controesempi che il cancello ha chiesto (06/11/2026). Per uno
    strumento .py non esiste cancello deterministico: questo E' il suo strato 1."""
    esiti = []

    def prova(nome, cond, dettaglio=''):
        esiti.append((nome, bool(cond), dettaglio))

    # 1 -- il controesempio che separa il codice dal suo docstring
    cl, pr = classifica('250604', {'Gold_Ichimoku_TK_ATR_EA'}, ['IchiCross long'])
    prova('250604: .chr con EA non nostro + commento di casa -> MERCATO',
          cl == 'MERCATO', '%s (%s)' % (cl, pr))
    # 2 -- la regressione che produsse -20.901,29
    cl, _ = classifica('0', set(), ['SUPERWAVE MANUALE SELL 1'])
    prova('magic 0 con commento di casa -> MANUALE', cl == 'MANUALE', cl)
    # 3 -- EA col nome che contiene uno spazio, magic numerico
    t = '--- SEDIA: ABTG_ScalperDirezionale (4)  su EURUSD   magic 779901   [chart9.chr] ---'
    m, viste, saltate = ea_dai_chr(t)
    prova('EA col nome con SPAZIO e magic numerico: catturato, non scartato',
          m.get('779901') == {'ABTG_ScalperDirezionale (4)'} and saltate == 0,
          '%s viste=%d saltate=%d' % (dict(m), viste, saltate))
    # 4 -- magic non numerico: saltato E CONTATO
    t2 = '--- SEDIA: Qualcosa Con Spazi  su XAUUSD   magic -   [chart1.chr] ---'
    m2, viste2, saltate2 = ea_dai_chr(t2)
    prova('magic non numerico: saltato E CONTATO', viste2 == 1 and saltate2 == 1 and not m2,
          'viste=%d saltate=%d' % (viste2, saltate2))
    # 5 -- esaustivita' sul CSV vero
    R = leggi_csv(CSV)
    if R is None:
        prova('esaustivita sul CSV', False, 'CSV assente')
    else:
        agg = aggrega(R)
        logs = sorted(glob.glob(LOGGLOB))
        testo = '\n'.join(io.open(f, encoding='utf-8', errors='replace').read() for f in logs)
        chr_map, _v, _s = ea_dai_chr(testo)
        tot = collections.defaultdict(lambda: [0, 0, 0.0])
        for mg, a in agg.items():
            cl, _ = classifica(mg, chr_map.get(mg, set()), [c for c, _ in a[2].most_common()])
            tot[cl][0] += 1; tot[cl][1] += a[0]; tot[cl][2] += a[1]
        nm = sum(v[0] for v in tot.values()); nop = sum(v[1] for v in tot.values())
        nnet = sum(v[2] for v in tot.values())
        prova('somma dei magic = magic distinti nel CSV', nm == len(agg), '%d vs %d' % (nm, len(agg)))
        prova('somma delle operazioni = righe del CSV', nop == len(R), '%d vs %d' % (nop, len(R)))
        vero = sum(netto(r) for r in R)
        prova('somma dei netti = netto totale del CSV (resto 0,00)',
              abs(nnet - vero) < 0.005, '%+.2f vs %+.2f' % (nnet, vero))
    # 6 -- le due liste sono DISGIUNTE (asseribile solo dopo aver tolto ICHICROSS)
    comuni = set(MARCHI_NOSTRI) & set(MARCHI_MERCATO)
    prova('MARCHI_NOSTRI e MARCHI_MERCATO sono disgiunte', not comuni, str(comuni))
    # 7 -- commento ignoto -> DA CONFERMARE, mai indovinato
    cl, _ = classifica('24759', set(), ['24759'])
    prova('commento ignoto -> DA CONFERMARE', cl == 'DA CONFERMARE', cl)

    print('AUTOTEST censimento_magic')
    ko = 0
    for nome, ok, det in esiti:
        print('  %s  %s%s' % ('PASS' if ok else 'FAIL', nome, ('   [' + det + ']') if (det and not ok) else ''))
        if not ok:
            ko += 1
    print('  %d prove, %d fallite' % (len(esiti), ko))
    return 1 if ko else 0


def main():
    R = leggi_csv(CSV)
    if R is None:
        print('manca', CSV)
        return 2
    logs = sorted(glob.glob(LOGGLOB))
    testo = '\n'.join(io.open(f, encoding='utf-8', errors='replace').read() for f in logs)
    chr_map, viste, saltate = ea_dai_chr(testo)
    print('log CODA_08 letti: %d  ·  righe SEDIA viste: %d  ·  senza magic numerico (saltate e contate): %d  ·  magic legati a un EA: %d'
          % (len(logs), viste, saltate, len(chr_map)))

    agg = aggrega(R)
    R100 = leggi_csv(CSV_100K)
    agg100 = aggrega(R100) if R100 is not None else {}

    righe = []
    for mg, a in agg.items():
        commenti = [c for c, _ in a[2].most_common()]
        cl, prova = classifica(mg, chr_map.get(mg, set()), commenti)
        righe.append((cl, -a[0], mg, a[0], a[1], prova, commenti, sorted(a[3])))
    righe.sort(key=lambda x: (ORDINE[x[0]], x[1]))

    tot = {k: [0, 0, 0.0] for k in ORDINE}
    for cl, _, mg, n, net, _p, _c, _s in righe:
        tot[cl][0] += 1; tot[cl][1] += n; tot[cl][2] += net

    out = []
    W = out.append
    W('# CENSIMENTO MAGIC -- la tabella `magic -> EA -> nostro/mercato`')
    W('')
    W('_Generato da `backtest_pipeline/censimento_magic.py` (**sola lettura**: legge il CSV del')
    W('TradeExporter e **tutti** i log `CODA_08` del runner; non apre MT5, non va in rete).')
    W('Prerequisito della **classe 1530**: senza questa tabella sono esposti il netto della')
    W('flotta, il censimento delle compresenze e il **criterio di uscita del 18/08**, che')
    W('decide **per famiglia** chi si spegne._')
    W('')
    W('## 🔴 PERIMETRO, e va letto prima dei numeri')
    W('')
    W('Questa tabella copre **un solo conto: il piccolo `50503392`** (`trades_auto.csv`).')
    W('**NON** include `trades_100k.csv` (100k `50504263`), dove **cinque** nostri magic hanno')
    W('altre **43** operazioni. 🔴 **E non e\' accademico: `770611` arriva cosi\' a n=20, che e\'')
    W('esattamente la soglia MERITO del criterio del 18/08** — e i due conti hanno **segno')
    W('opposto** (piccolo −212,16 · 100k +549,75).')
    W('')
    W('📏 **`n` e\' additivo fra i conti e decide la soglia; il NETTO no**: il lotto medio di')
    W('`770611` e\' **0,591 sul piccolo** contro **7,356 sul 100k** (**12,4x**), quindi sommare i')
    W('netti sarebbe la classe **1526** (basi mescolate) nella forma piu\' rumorosa.')
    W('')
    W('## Riepilogo (piccolo `50503392`)')
    W('')
    W('| classe | magic | operazioni | netto |')
    W('|---|---|---|---|')
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        W('| **%s** | %d | %d | **%+.2f** |' % (k, tot[k][0], tot[k][1], tot[k][2]))
    W('| _somma_ | %d | %d | %+.2f |' % (sum(v[0] for v in tot.values()),
                                         sum(v[1] for v in tot.values()),
                                         sum(v[2] for v in tot.values())))
    W('')
    W('## 🔴 L\'ETICHETTA DELLA PAGELLA E\' SBAGLIATA, e questa tabella lo dimostra')
    W('')
    nz = [r for r in R if r['magic'] != '0']
    W('`analizza_trades.py` definisce la flotta come `magic == 0 -> fuori` e stampa **«Totale')
    W('della sola flotta»**. Misurato con la partizione dichiarata qui sopra: `magic != 0` sono')
    W('**%d operazioni / %+.2f**, di cui **%d / %+.2f sono MERCATO** = **%.0f%% delle righe**.'
      % (len(nz), sum(netto(r) for r in nz), tot['MERCATO'][1], tot['MERCATO'][2],
         100.0 * tot['MERCATO'][1] / max(len(nz), 1)))
    W('')
    W('👉 **«Sola flotta» e\' da mesi l\'etichetta di un numero che non e\' la flotta.** In certe')
    W('giornate non cambia nulla (il 30/10, il 03, 04 e 05/11 tutte le righe sono nostre), ma il')
    W('**14/10** erano **1.206 righe di mercato contro 13 nostre**.')
    W('')
    W('## La regola, dichiarata prima dei numeri — SEI casi, nell\'ordine del codice')
    W('')
    W('0. **MANUALE** se `magic == 0`: non e\' un EA, MT5 ci mette le operazioni **a mano**.')
    W('   🔴 Era il **primo** caso del codice e mancava da tutte e due le liste pubblicate')
    W('   (classe **1532**), pur spostando **%+.2f**.' % tot['MANUALE'][2])
    W('1. **NOSTRO** se il preset `.chr` associa al magic un EA `ABTG_*` o `CLAU12_*`.')
    W('2. **MERCATO** se il preset associa un EA con un altro nome. 🔴 Controesempio reale:')
    W('   `250604` sta in un nostro `.chr`, ma l\'EA e\' `Gold_Ichimoku_TK_ATR_EA`:')
    W('   **stare in un nostro grafico non rende nostro un EA.**')
    W('3. **MERCATO** se il commento porta un marchio di mercato noto.')
    W('4. **NOSTRO** se il commento porta un marchio delle nostre famiglie.')
    W('5. **DA CONFERMARE** in ogni altro caso. 🔴 **Non si indovina: si stampa.**')
    W('')
    W('🔴 **`magic != 0` NON vuol dire "nostro"**, e nessun criterio numerico separa i due')
    W('insiemi: i magic di mercato hanno valori qualunque (`888`, `1234567`, `5318008`,')
    W('`20260810`, `778899`...). 📌 Le due liste di marchi sono scritte **a mano** dai commenti')
    W('del CSV e dai preset `EA_Comment=` — **non** dai sorgenti `.mq5`, che non contengono')
    W('queste stringhe — e sono **disgiunte** (l\'autotest lo asserisce).')
    W('')
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        W('## %s (%d magic, %d operazioni, netto %+.2f)' % (k, tot[k][0], tot[k][1], tot[k][2]))
        W('')
        W('| magic | n | netto | anche sul 100k | prova | commenti |')
        W('|---|---|---|---|---|---|')
        for cl, _, mg, n, net, prova, com, sym in righe:
            if cl != k:
                continue
            if mg in agg100:
                b = agg100[mg]
                extra = '**n=%d, %+.2f**' % (b[0], b[1])
            else:
                extra = '—'
            W('| `%s` | %d | %+.2f | %s | %s | %s |' % (
                mg, n, net, extra, prova,
                ' / '.join(c if c else '_(vuoto)_' for c in com[:3])[:64]))
        W('')
    io.open(USCITA, 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    print('-> scritto', USCITA)
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        print('   %-14s %3d magic  %5d operazioni  netto %+10.2f' % (k, tot[k][0], tot[k][1], tot[k][2]))
    return 0


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(autotest())
    sys.exit(main())
