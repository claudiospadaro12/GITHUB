#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MARCATORE_CENSIMENTO_MAGIC_v1

La tabella `magic -> EA -> nostro/mercato`, prerequisito della classe 1530
(05/11/2026): senza di essa sono esposti il netto della flotta, il censimento
delle compresenze e il CRITERIO DI USCITA del 18/08, che decide per FAMIGLIA
chi si spegne.

Due sorgenti, nessuna inventata:
  (A) i preset ricostruiti dai .chr dal runner notturno (sola lettura):
      backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_*.log
      -> da' `magic -> nome del programma EA` per le sedie SALVATE nei profili.
  (B) data/statements/trades_auto.csv -> `magic -> commento, n, netto, simboli`.

REGOLA DI CLASSIFICAZIONE, dichiarata prima dei numeri:
  NOSTRO   se (A) associa al magic un EA il cui nome inizia per ABTG_ o CLAU12_
           -- e' la prova piu' forte: il programma e' nostro per costruzione.
  NOSTRO   se il commento corrisponde a una FAMIGLIA di commenti che i nostri
           EA scrivono (elenco MARCHI_NOSTRI, ricavato dai sorgenti in mql5/).
  MERCATO  se (A) associa un EA il cui nome NON e' ABTG_/CLAU12_
           -- controesempio reale: magic 250604 sta in un .chr, ma l'EA e'
           `Gold_Ichimoku_TK_ATR_EA`: stare in un grafico non rende nostri.
  MERCATO  se il commento corrisponde a MARCHI_MERCATO.
  DA CONFERMARE  in tutti gli altri casi. NON si indovina: si stampa.

CHE COSA NON FA: non decide i DA CONFERMARE, non tocca niente sul campo,
non apre MT5. Legge due file e stampa una tabella.
"""
import csv, re, io, glob, collections, sys, os

CSV = 'data/statements/trades_auto.csv'
LOGGLOB = 'backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_*.log'
USCITA = 'report/CENSIMENTO_MAGIC.md'

# famiglie di commenti che i NOSTRI EA scrivono (prefissi, confronto maiuscolo)
MARCHI_NOSTRI = [
 'BULGE_', 'DAX APERTURA', 'DAX LIVE', 'DAX M3', 'APERTURA MARCO',
 'NASDAQ APERTURA', 'NASDAQ LIVE', 'DOW APERTURA', 'MAXMIN', 'ORB ',
 'ORB OTT', 'SUPERWAVE', 'SW DOW', 'STREV', 'EMA200', 'LARRY ', 'COST ',
 'GAPCONT', 'GAP ', 'EASYTREND', 'EZ ', 'PTE ', 'BB ', 'NIGHTLY',
 'LONDRA', 'POSTNEWS', 'FOMC POSTNEWS', 'ECB POSTNEWS', 'NFP POSTNEWS',
 'ICHICROSS',   # NB: questo e' di MERCATO, vedi MARCHI_MERCATO: ha priorita'
]
# marchi di EA di MERCATO (hanno priorita' sui MARCHI_NOSTRI)
MARCHI_MERCATO = [
 'FINLABX', 'CF S [F]', 'CF B [F]', 'SNIPING', 'DARK VENUS', 'HEDGINGMARTINGALE',
 'NANG_KWAK', 'BASKET_', 'TIG BREAKOUT', 'APEX ORIGIN', 'MARCALBRECHTTRADING',
 'MP BY SPLPULSE', 'SSP SCALP', 'SSPV', 'SUPERSCALP PRO', 'XAUUSD 5 MINUTE',
 'GUNNER E', 'DRESEA', 'ICHICROSS', 'NASDAQMASTEREA', 'MAXOPPCATCHER',
 'NQ_V21', 'GZ BUY', 'GZ SELL', 'SAMPLE COMMENT', 'SELLSTOP', 'BUYSTOP',
 'NIGHT_BREAK_BOX',
]

def netto(r):
    return float(r['profit']) + float(r['commission']) + float(r['swap'])

def ea_dai_chr(testo):
    m = collections.defaultdict(set)
    for g in re.finditer(r'--- SEDIA: (\S+)\s+su (\S+)\s+magic (\d+)\s+\[(\S+)\]', testo):
        ea, _sym, mg, _ch = g.groups()
        m[mg].add(ea)
    return m

def classifica(mg, eas, commenti):
    """-> (classe, prova). L'ordine dei casi E' la regola."""
    if mg == '0':
        # magic 0 non e' un EA: MT5 lo mette sulle operazioni MANUALI.
        # Va in una classe sua, e NON nel netto della flotta -- lo dichiara
        # anche la pagella automatica ("le righe a magic 0 stanno fuori").
        # Qui porta -19.667,88, dentro cui lo stop out del 22/10 (-16.359,15)
        # che NON era nostro: contarle come flotta falserebbe tutto.
        return 'MANUALE', 'magic 0 = operazioni a mano, non un EA'
    nostri_ea = [e for e in eas if e.upper().startswith(('ABTG_', 'CLAU12_'))]
    altri_ea  = [e for e in eas if not e.upper().startswith(('ABTG_', 'CLAU12_'))]
    if nostri_ea:
        return 'NOSTRO', 'preset .chr: ' + ' / '.join(sorted(nostri_ea))
    if altri_ea:
        return 'MERCATO', 'preset .chr, EA non nostro: ' + ' / '.join(sorted(altri_ea))
    su = [c.upper() for c in commenti if c.strip()]
    for marchio in MARCHI_MERCATO:
        if any(c.startswith(marchio) or marchio in c for c in su):
            return 'MERCATO', 'commento di mercato: ' + marchio
    for marchio in MARCHI_NOSTRI:
        if any(c.startswith(marchio) for c in su):
            return 'NOSTRO', 'commento di casa: ' + marchio
    if not su:
        return 'DA CONFERMARE', 'commento VUOTO e magic non nei .chr'
    return 'DA CONFERMARE', 'commento non riconosciuto: ' + commenti[0][:30]

def main():
    if not os.path.exists(CSV):
        print('manca', CSV); return 2
    logs = sorted(glob.glob(LOGGLOB))
    if not logs:
        print('manca un log CODA_08: la colonna del preset restera vuota')
    testo = io.open(logs[-1], encoding='utf-8', errors='replace').read() if logs else ''
    chr_map = ea_dai_chr(testo)

    R = list(csv.DictReader(io.open(CSV, encoding='utf-8', errors='replace'), delimiter=';'))
    agg = collections.defaultdict(lambda: [0, 0.0, collections.Counter(), set()])
    for r in R:
        a = agg[r['magic']]
        a[0] += 1; a[1] += netto(r)
        a[2][r['strategy'].strip()] += 1
        a[3].add(r['symbol'])

    righe = []
    for mg, a in agg.items():
        commenti = [c for c, _ in a[2].most_common()]
        cl, prova = classifica(mg, chr_map.get(mg, set()), commenti)
        righe.append((cl, -a[0], mg, a[0], a[1], prova, commenti, sorted(a[3])))
    ordine = {'NOSTRO': 0, 'DA CONFERMARE': 1, 'MERCATO': 2, 'MANUALE': 3}
    righe.sort(key=lambda x: (ordine[x[0]], x[1]))

    tot = {k: [0, 0, 0.0] for k in ordine}
    for cl, _, mg, n, net, _p, _c, _s in righe:
        tot[cl][0] += 1; tot[cl][1] += n; tot[cl][2] += net

    out = []
    W = out.append
    W('# CENSIMENTO MAGIC -- la tabella `magic -> EA -> nostro/mercato`')
    W('')
    W('_Generato da `backtest_pipeline/censimento_magic.py` (sola lettura: legge il CSV')
    W('del TradeExporter e il log `CODA_08` del runner). Prerequisito della **classe 1530**:')
    W('senza questa tabella sono esposti il netto della flotta, il censimento delle')
    W('compresenze e il **criterio di uscita del 18/08**, che decide **per famiglia**._')
    W('')
    W('## Riepilogo')
    W('')
    W('| classe | magic | operazioni | netto |')
    W('|---|---|---|---|')
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        W('| **%s** | %d | %d | **%+.2f** |' % (k, tot[k][0], tot[k][1], tot[k][2]))
    W('')
    W('## La regola, dichiarata prima dei numeri')
    W('')
    W('1. **NOSTRO** se il preset `.chr` associa al magic un EA `ABTG_*` o `CLAU12_*`.')
    W('2. **MERCATO** se il preset associa un EA con un altro nome. 🔴 Controesempio')
    W('   reale: `250604` sta in un `.chr`, ma l\'EA e\' `Gold_Ichimoku_TK_ATR_EA`:')
    W('   **stare in un nostro grafico non rende nostro un EA.**')
    W('3. **MERCATO** se il commento porta un marchio di mercato noto.')
    W('4. **NOSTRO** se il commento porta un marchio delle nostre famiglie.')
    W('5. **DA CONFERMARE** in ogni altro caso. 🔴 **Non si indovina: si stampa.**')
    W('')
    W('🔴 **`magic != 0` NON vuol dire "nostro"**, e nessun criterio numerico separa i')
    W('due insiemi: i magic di mercato hanno valori qualunque (`888`, `1234567`,')
    W('`5318008`, `20260810`, `778899`...).')
    W('')
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        W('## %s (%d magic, %d operazioni, netto %+.2f)' % (k, tot[k][0], tot[k][1], tot[k][2]))
        W('')
        W('| magic | n | netto | prova | commenti | simboli |')
        W('|---|---|---|---|---|---|')
        for cl, _, mg, n, net, prova, com, sym in righe:
            if cl != k: continue
            W('| `%s` | %d | %+.2f | %s | %s | %s |' % (
                mg, n, net, prova,
                ' / '.join(c if c else '_(vuoto)_' for c in com[:3])[:70],
                ' '.join(sym[:5]) + (' ...' if len(sym) > 5 else '')))
        W('')
    io.open(USCITA, 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    print('-> scritto', USCITA)
    for k in ('NOSTRO', 'DA CONFERMARE', 'MERCATO', 'MANUALE'):
        print('   %-14s %3d magic  %5d operazioni  netto %+10.2f' % (k, tot[k][0], tot[k][1], tot[k][2]))
    return 0

if __name__ == '__main__':
    sys.exit(main())
