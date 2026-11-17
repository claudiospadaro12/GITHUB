#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MQL5_Market_Hunter.py - strumento di SCOUTING a punteggio per Expert Advisor del Market MQL5.
NON scarica ne estrae nulla dal sito (le pagine del Market hanno condizioni d'uso e i file .ex5 sono protetti): lavora su una tabella che compili
tu (o che mi incolli) leggendo la pagina pubblica di ogni prodotto e il suo SEGNALE su conto reale. Applica filtri di scarto duri, un punteggio e scrive
una scheda con la checklist del test in tester (scatola nera: si prova con i nostri periodi e costi, senza estrarre le regole).
Uso:   python3 MQL5_Market_Hunter.py candidati.csv [--out cartella]      |   python3 MQL5_Market_Hunter.py --modello   (scrive candidati_MODELLO.csv)
Colonne (separatore ;): nome;url;prezzo_usd;rating;n_recensioni;mesi_sul_market;mesi_da_ultimo_aggiornamento;segnale_reale_mesi;segnale_rendimento_pct;
  segnale_dd_pct;segnale_trades;dichiara_martingala;dichiara_grid;dichiara_sl;dichiara_prop;simboli;note   (si/no per i campi dichiara_*)
ATTENZIONE: un EA del Market lo usano in molti: per una prop e il comportamento IDENTICO tra conti che crea il rischio. Serve come fonte di idee e confronto, non come flotta."""
import csv, sys, os, argparse

COLONNE = ['nome','url','prezzo_usd','rating','n_recensioni','mesi_sul_market','mesi_da_ultimo_aggiornamento','segnale_reale_mesi','segnale_rendimento_pct','segnale_dd_pct','segnale_trades','dichiara_martingala','dichiara_grid','dichiara_sl','dichiara_prop','simboli','note']
SOGLIE = dict(mesi_segnale=6, dd_max=20.0, trades_min=100, agg_max_mesi=12, recensioni_min=10)

def f(x, d=0.0):
    try: return float(str(x).replace(',', '.').strip())
    except Exception: return d

def si(x): return str(x).strip().lower() in ('si', 'sì', 'yes', 's', 'y', '1', 'true')

def giudica(r):
    scarti = []
    if si(r['dichiara_martingala']): scarti.append('dichiara martingala')
    if si(r['dichiara_grid']): scarti.append('dichiara grid/averaging')
    if not si(r['dichiara_sl']): scarti.append('stop loss non dichiarato')
    if f(r['segnale_reale_mesi']) < SOGLIE['mesi_segnale']: scarti.append('segnale reale < %d mesi' % SOGLIE['mesi_segnale'])
    if f(r['segnale_dd_pct']) > SOGLIE['dd_max']: scarti.append('DD segnale > %.0f%%' % SOGLIE['dd_max'])
    if f(r['segnale_trades']) < SOGLIE['trades_min']: scarti.append('< %d trade nel segnale' % SOGLIE['trades_min'])
    if f(r['mesi_da_ultimo_aggiornamento'], 99) > SOGLIE['agg_max_mesi']: scarti.append('non aggiornato da > %d mesi' % SOGLIE['agg_max_mesi'])
    if f(r['n_recensioni']) < SOGLIE['recensioni_min']: scarti.append('poche recensioni (< %d)' % SOGLIE['recensioni_min'])
    ret, dd = f(r['segnale_rendimento_pct']), max(f(r['segnale_dd_pct']), 0.1)
    punti = 0.0
    punti += min(f(r['segnale_reale_mesi']), 24) / 24 * 25                 # anzianita del segnale reale
    punti += max(min(ret / dd, 5), 0) / 5 * 25                              # rendimento / drawdown
    punti += min(f(r['segnale_trades']), 500) / 500 * 15                    # campione
    punti += min(f(r['rating']), 5) / 5 * 10 + min(f(r['n_recensioni']), 100) / 100 * 5
    punti += 10 if si(r['dichiara_prop']) else 0                            # dichiarazione, NON verificata
    punti += 10 if f(r['mesi_sul_market']) >= 12 else 0
    if ret > 300 and f(r['segnale_reale_mesi']) < 12: scarti.append('rendimento spettacolare su pochi mesi (sospetto)')
    return scarti, round(punti, 1)

SCHEDA = """# Scheda di scouting: {nome}
Punteggio {punti}/100 | URL: {url} | simboli: {simboli}
Segnale reale: {mesi} mesi, rendimento {ret}%, DD {dd}%, {trades} trade. Dichiarazioni (NON verificate): martingala={mart}, grid={grid}, SL={sl}, prop={prop}.

## Prima di spendere tempo (verifiche manuali)
1. Il segnale e su conto REALE (non demo) e il saldo e pubblico? Il DD del segnale coincide con quello dichiarato nella descrizione?
2. Leggi le recensioni negative piu recenti: cerca "martingale", "grid", "stop loss rimosso", "in perdita dopo l'aggiornamento".
3. Condizioni della prop firm scelta sugli EA di terzi e sul "copy/stessa strategia": un prodotto venduto a molti puo violarle. Verifica nel regolamento ufficiale.
4. Quanto costa il prodotto contro il capitale previsto? (la licenza e per numero di attivazioni).

## Test in tester (scatola nera, solo tester, mai conti reali)
- Scarica la DEMO dal terminale (scheda Market): la demo gira solo nel tester e puo avere input bloccati; non si estraggono regole dal file .ex5.
- Periodi come la campagna: dentro-campione 2015-2020 (se i dati lo coprono), fuori campione 2021-2022 e 2023-2024, hold-out 2025-2026 intatto. Costi: 3,6 EUR a operazione oltre al tester. Orologio server BCM GMT+1 fisso: prima di leggere i risultati controlla l'ora di sessione per estate/inverno (regola fissa del progetto).
- Porte (stesse della campagna): PF netto >= 1,20 fuori campione in entrambi i blocchi, profitto > 0, >= 20 operazioni, t sul rendimento giornaliero, DD misurato al lotto che scegli tu.
- Correlazione con gli altri EA della flotta (serie giornaliere, `Correlazione.py`): <= 0,30 = diverso, > 0,60 = stessa cosa.
- Esito: il risultato va scritto nel registro (anche se brutto) con il numero di prodotti provati.
"""

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('csv', nargs='?'); ap.add_argument('--out', default='market_hunter_out'); ap.add_argument('--modello', action='store_true')
    a = ap.parse_args()
    if a.modello or not a.csv:
        with open('candidati_MODELLO.csv', 'w', newline='', encoding='utf-8') as fh:
            w = csv.writer(fh, delimiter=';'); w.writerow(COLONNE); w.writerow(['ESEMPIO_NON_REALE','https://www.mql5.com/...','0','4.5','20','18','3','10','25','12','240','no','no','si','no','XAUUSD','esempio inventato per mostrare il formato'])
        print('scritto candidati_MODELLO.csv (compilalo leggendo le pagine pubbliche e i segnali)'); return
    righe = list(csv.DictReader(open(a.csv, encoding='utf-8-sig'), delimiter=';'))
    os.makedirs(a.out, exist_ok=True); ris = []
    for r in righe:
        for c in COLONNE: r.setdefault(c, '')
        scarti, punti = giudica(r); ris.append((r, scarti, punti))
    ris.sort(key=lambda x: (len(x[1]) > 0, -x[2]))
    with open(os.path.join(a.out, 'classifica.csv'), 'w', newline='', encoding='utf-8') as fh:
        w = csv.writer(fh, delimiter=';'); w.writerow(['nome', 'esito', 'punti', 'motivi_di_scarto'])
        for r, sc, p in ris: w.writerow([r['nome'], 'SCARTATO' if sc else 'CANDIDATO', p, ' | '.join(sc)])
    for r, sc, p in ris:
        print('%-30s %-9s %5.1f  %s' % (r['nome'][:30], 'SCARTATO' if sc else 'CANDIDATO', p, ' | '.join(sc)))
        if not sc:
            open(os.path.join(a.out, 'scheda_%s.md' % ''.join(ch if ch.isalnum() else '_' for ch in r['nome'])), 'w', encoding='utf-8').write(SCHEDA.format(
                nome=r['nome'], punti=p, url=r['url'], simboli=r['simboli'], mesi=r['segnale_reale_mesi'], ret=r['segnale_rendimento_pct'], dd=r['segnale_dd_pct'], trades=r['segnale_trades'],
                mart=r['dichiara_martingala'], grid=r['dichiara_grid'], sl=r['dichiara_sl'], prop=r['dichiara_prop']))
    print('classifica e schede in', a.out)

if __name__ == '__main__':
    main()
