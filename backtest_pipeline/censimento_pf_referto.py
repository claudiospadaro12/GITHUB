#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json, os, collections
D = json.load(open('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/dump.json'))
rows, stat = D['rows'], D['stat']
NM = '[NON MISURATO]'

def f2(v):  return NM if v is None else ('%.2f' % v)
def f0(v):  return NM if v is None else ('%.0f' % v)
def i(v):   return NM if v is None else str(int(v))
def pz(r, p):
    a, b = r.get(p+'_passate'), r.get(p+'_uniche')
    if a is None: return NM
    return '%d' % a if a == b else '%d (%d uniche)' % (a, b)
def tf(v):  return 'TF-OTT' if str(v).startswith('MISTO(') else v
def esc(s): return str(s).replace('|', '\\|')

# ---- conteggi round: una "corsa" = una cartella di risultati
cartelle = sorted({r['cartella'] for r in rows})
round_like = sorted({c for c in cartelle})

con_oos  = [r for r in rows if r.get('oos_pf_med') is not None]
senza    = [r for r in rows if r.get('oos_pf_med') is None]
senza.sort(key=lambda r: -(r.get('is_pf_med') if r.get('is_pf_med') is not None
                           else (r.get('unica_pf_med') or -9e9)))
vicini   = [r for r in con_oos if r['vicino'] == 'SI']

HEAD = ('| Motore | Simbolo | TF | Etichetta/Round | Cartella | pass IS | PF med IS | PF picco IS | '
        'Trades IS | DD% IS | Profit IS | pass OOS | PF med OOS | PF picco OOS | Trades OOS | DD% OOS | '
        'Profit OOS | VICINO ALLA SOGLIA? |')
SEP  = '|' + '---|' * 18

def riga(r):
    return '| ' + ' | '.join([
        esc(r['motore']), esc(r['simbolo']), esc(tf(r['tf'])), esc(r['etichetta']), esc(r['cartella']),
        pz(r,'is'), f2(r.get('is_pf_med')), f2(r.get('is_pf_max')),
        i(r.get('is_trades_med')), f2(r.get('is_dd_med')), f0(r.get('is_profit_med')),
        pz(r,'oos'), f2(r.get('oos_pf_med')), f2(r.get('oos_pf_max')),
        i(r.get('oos_trades_med')), f2(r.get('oos_dd_med')), f0(r.get('oos_profit_med')),
        r['vicino'],
    ]) + ' |'

HEAD2 = ('| Motore | Simbolo | TF | Etichetta/Round | Cartella | Finestra | passate | PF mediano | '
         'PF picco | Trades (cella mediana) | DD% | Profit |')
SEP2  = '|' + '---|' * 12

def riga2(r):
    fase = 'IS' if r.get('is_pf_med') is not None else 'UNICA'
    p = 'is' if fase == 'IS' else 'unica'
    return '| ' + ' | '.join([
        esc(r['motore']), esc(r['simbolo']), esc(tf(r['tf'])), esc(r['etichetta']), esc(r['cartella']),
        fase, pz(r,p), f2(r.get(p+'_pf_med')), f2(r.get(p+'_pf_max')),
        i(r.get(p+'_trades_med')), f2(r.get(p+'_dd_med')), f0(r.get(p+'_profit_med')),
    ]) + ' |'

O = []
w = O.append
w('# 🔬 CENSIMENTO DEI PROFIT FACTOR MISURATI — 09/09/2026')
w('')
w('**Costruito SOLO sui CSV del tester.** Nessun numero viene dai referti `.md`, nessun')
w('numero e' + "'" + ' stimato o arrotondato "a occhio". Dove il dato non esiste nei CSV c\'e\' scritto')
w('`[NON MISURATO]` e basta.')
w('')
w('- Sorgente: `backtest_pipeline/risultati_archivio/`, `backtest_pipeline/risultati_prove/`, `backtest_pipeline/prove/`')
w('- Script rifacibile: `backtest_pipeline/censimento_pf.py` (rimacina i CSV) + `backtest_pipeline/censimento_pf_referto.py` (riscrive questo referto)')
w('- CSV grezzo aggregato: `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`')
w('')
w('## 📐 COME SONO STATI CALCOLATI I NUMERI (regole dichiarate)')
w('')
w('1. **Cella MEDIANA** = si ordinano TUTTE le passate della corsa per Profit Factor e si')
w('   prende quella centrale (per numero pari di passate: quella immediatamente SOTTO la')
w('   meta\'). `Trades`, `Equity DD %` e `Profit` riportati sono **quelli di QUELLA passata**,')
w('   non medie di comodo. E\' la regola di casa: *centro dell\'altopiano, MAI il picco*.')
w('2. **Cella MIGLIORE (picco)** = passata con PF massimo. E\' riportata **accanto** alla')
w('   mediana proprio perche\' da sola mente: se picco e mediana divergono di molto, quella')
w('   corsa e\' rumore, non altopiano.')
w('2bis. **Le passate con ESITO IDENTICO contano UNA volta.** %d CSV su %d contengono passate' % (stat['csv_con_esiti_duplicati'], stat['csv_usati']))
w('   che ripetono lo stesso `Profit`/`PF`/`Trades`/`DD`: sono **parametri inerti** — la griglia')
w('   ha mosso una manopola che non cambia niente. Esempio misurato:')
w('   `Aperture_Ingresso/DAX_ingresso.csv` ha **160 passate ma solo 20 esiti distinti**.')
w('   Contarle tutte sposterebbe la mediana **senza che nessuna misura sia cambiata**, quindi')
w('   mediana e picco si calcolano sugli **esiti distinti**; la colonna `pass` mostra entrambi')
w('   i numeri quando divergono (`160 (20 uniche)`), cosi\' il collasso si vede.')
w('3. **Le passate con `Trades = 0` sono ESCLUSE dalle statistiche.** Regola di casa:')
w('   `Trades = 0` NON e\' "nessun edge", e\' **"non e\' girata"**. Sono contate a parte.')
w('4. **Parser numerico**: accetta punto E virgola decimale (anche `1.234,56`); le righe non')
w('   numeriche vengono scartate e contate.')
w('5. **TF**: dedotto in quest\'ordine — (a) token nel nome file, (b) colonna `InpTF` se ha un')
w('   valore unico (enum MQL5 -> M1/M5/M15/M30/H1/H4/D1), (c) nome cartella. Se `InpTF` era')
w('   **ottimizzato** su piu\' valori la cella dice `TF-OTT` (il TF non e\' UNO). Altrimenti `[NON MISURATO]`.')
w('6. **`VICINO ALLA SOGLIA?` = SI** quando **PF OOS della cella mediana >= 0,90** (entro il')
w('   20% dalla soglia di casa 1,10) **E** `n >= 100`, dove **n = Trades della cella mediana OOS**')
w('   (l\'unita\' di misura del progetto e\' l\'OPERAZIONE, non la passata). Se manca l\'OOS: `[NON MISURATO]`.')
w('')
w('## 🔢 I CONTEGGI')
w('')
w('| Cosa | Quanti |')
w('|---|---|')
w('| CSV totali visti nelle cartelle sorgente | %d |' % stat['totali'])
w('| CSV **di risultati** (intestazione con `Profit Factor` + `Trades`) | **%d** |' % stat['risultati'])
w('| CSV NON di risultati (tick, deal, sonde, calendari...) — ignorati | %d |' % stat['non_risultati'])
w('| CSV di risultati effettivamente **usati** | **%d** |' % stat['csv_usati'])
w('| CSV **scartati perche\' TUTTE le passate hanno `Trades = 0`** ("non e\' girata") | **%d** |' % stat['csv_tutti_zero'])
w('| CSV illeggibili / con la sola intestazione | %d |' % stat.get('illeggibili_o_vuoti', 0))
w('| Passate singole con `Trades = 0` escluse dentro CSV altrimenti validi | %d |' % stat['passate_zero'])
w('| CSV con almeno una passata a `Trades = 0` | %d |' % len(D['zero_partial']))
w('| CSV con **passate a esito identico** (parametri inerti nella griglia) | **%d** |' % stat['csv_con_esiti_duplicati'])
w('| **Cartelle di corsa distinte ("round")** | **%d** |' % len(cartelle))
w('| Righe del censimento = coppie (motore, simbolo, TF, etichetta, cartella) | **%d** |' % len(rows))
w('| ...di cui **con una finestra OOS misurata** | **%d** |' % len(con_oos))
w('| ...di cui **senza OOS** (solo IS, o finestra unica/regime) | %d |' % len(senza))
w('| 🟢 Righe **VICINO ALLA SOGLIA = SI** | **%d** |' % len(vicini))
w('')
w('> ⚠️ **"Round" qui = cartella di risultati, non numero di round del registro.** Le cartelle')
w('> sono %d e non coincidono uno-a-uno con gli R-numeri (alcuni round hanno piu\' cartelle,' % len(cartelle))
w('> alcune cartelle raccolgono piu\' round). Il numero degli R-numeri sta nei referti, che qui')
w('> **non sono stati letti apposta**: questo censimento e\' costruito solo sui numeri.')
w('')
w('---')
w('')
w('## 🟢 TABELLA A — I %d CANDIDATI "VICINO ALLA SOGLIA" (PF OOS mediano >= 0,90 e n >= 100)' % len(vicini))
w('')
w('Questi sono quelli che **vale la pena riaprire**: hanno un OOS vero, un campione che regge')
w('(>= 100 operazioni nella cella mediana) e stanno entro il 20% dalla soglia 1,10.')
w('Ordinati per **PF OOS della cella mediana, decrescente**.')
w('')
w(HEAD); w(SEP)
for r in vicini: w(riga(r))
w('')
w('---')
w('')
w('## 📋 TABELLA B — TUTTE LE CORSE CON OOS MISURATO (%d righe)' % len(con_oos))
w('')
w('Ordinata per **PF OOS della cella mediana, decrescente**.')
w('')
w('> 🔴 **Come si legge la cima di questa tabella.** In alto NON ci sono i vincitori: ci sono i')
w('> **campioni sottili**. Un PF OOS mediano di 189 o di 5,03 su 2-13 operazioni e\' rumore, non')
w('> un motore. Per questo esiste la colonna `Trades OOS`: **se e\' un numero piccolo, il PF')
w('> accanto non vuol dire niente**. La colonna `VICINO ALLA SOGLIA?` e\' il filtro serio.')
w('> Stessa cosa per `passate`: con 1-2 passate non esiste nessun "altopiano", mediana e picco')
w('> coincidono per costruzione.')
w('')
w(HEAD); w(SEP)
for r in con_oos: w(riga(r))
w('')
w('---')
w('')
w('## 📋 TABELLA C — CORSE SENZA OOS (%d righe): solo IS, oppure finestra unica / prova di regime' % len(senza))
w('')
w('Qui rientrano gli **scan a tappeto** (`scan_ABTG_*`), le **prove di regime** R50/R57/R59/R80')
w('(TORO / ORSO / LATERALE / CROLLO — che per costruzione NON hanno un OOS: sono finestre')
w('dichiarate) e le validazioni realtick a finestra unica. **Non hanno un PF OOS: non possono')
w('essere ordinate col criterio della Tabella B**, e la colonna `VICINO ALLA SOGLIA?` per loro')
w('vale `[NON MISURATO]`. Ordinate per PF mediano della loro unica finestra, decrescente.')
w('')
w(HEAD2); w(SEP2)
for r in senza: w(riga2(r))
w('')
w('---')
w('')
w('## 🚫 I %d CSV CON `Trades = 0` SU TUTTE LE PASSATE — "NON E\' GIRATA", non "nessun edge"' % len(D['zero_files']))
w('')
w('Regola di casa esplicita: un file con zero operazioni **non ha misurato niente**. Non e\' una')
w('bocciatura del motore, e\' una corsa che non e\' partita (simbolo/periodo/filtri che non hanno')
w('mai fatto scattare un ingresso). Vanno rifatte, non archiviate come "senza edge".')
w('')
w('| CSV | passate tutte a Trades=0 |')
w('|---|---|')
for rel, n in sorted(D['zero_files']):
    w('| `%s` | %d |' % (rel, n))
w('')
grp0 = collections.Counter(os.path.dirname(rel) for rel, _ in D['zero_files'])
w('**Concentrazione per cartella:**')
w('')
w('| Cartella | CSV a zero |')
w('|---|---|')
for c, n in grp0.most_common():
    w('| `%s` | %d |' % (c, n))
w('')
w('---')
w('')
w('## 🕳️ BUCHI DICHIARATI')
w('')
w('Quello che questo censimento **non** ha potuto misurare, detto per nome.')
w('')
w('### 1. Cartelle / file non letti')
if D['buchi']:
    w('')
    w('| Percorso | Motivo |')
    w('|---|---|')
    for a, b in D['buchi']: w('| `%s` | %s |' % (a, b))
else:
    w('')
    w('**Nessuna.** Tutte e %d le cartelle sotto `risultati_archivio/`, `risultati_prove/` e' % len(cartelle))
    w('`prove/` sono state aperte e lette; tutti e %d i CSV con intestazione da tester' % stat['risultati'])
    w('sono stati parsati senza errori di lettura o di codifica. Zero file illeggibili, zero file')
    w('con la sola intestazione.')
w('')
w('### 2. Buchi di INFORMAZIONE (il dato non c\'e\' nel CSV, quindi non e\' stato inventato)')
w('')
n_tf   = sum(1 for r in rows if r['tf'] == NM)
n_tfo  = sum(1 for r in rows if str(r['tf']).startswith('MISTO('))
n_sym  = sum(1 for r in rows if r['simbolo'] == NM)
w('| Buco | Righe colpite | Perche\' |')
w('|---|---|---|')
w('| **TF `[NON MISURATO]`** | %d | Il nome file non porta il TF, la colonna `InpTF` non c\'e\' nell\'intestazione e la cartella non lo dice. Il TF esiste, ma **non e\' scritto da nessuna parte nei dati**: dedurlo sarebbe stimare. |' % n_tf)
w('| **TF = `TF-OTT`** | %d | `InpTF` era un parametro OTTIMIZZATO: la corsa non ha UN timeframe, ne ha molti. Il PF mediano di quella corsa e\' quindi mediano **anche sui TF**, e va letto sapendolo. |' % n_tfo)
w('| **Simbolo `[NON MISURATO]`** | %d | Corse `R113_*` e `R114_*`: il nome file (`R113_F0_00_metro`) non contiene il simbolo e i CSV non hanno colonna `Simbolo`. **Non l\'ho dedotto dai criteri**: sarebbe un\'inferenza, non una misura. |' % n_sym)
w('| **`PTEGBP_*` / `PTEJPY_*` (round R80)** | 40 | Il motore e\' PTE (dichiarato dal nome), ma **il simbolo esatto non e\' nel file**: resta scritto `PTEGBP`/`PTEJPY` cosi\' com\'e\'. Che siano GBPUSD e USDJPY e\' probabile ma **non misurato**, e non l\'ho scritto come se lo fosse. |')
w('')
w('### 3. Buchi di METODO (limiti veri di questa tabella, da sapere prima di usarla)')
w('')
w('- 🔴 **Un PF non e\' un verdetto.** Questa tabella non sa se una corsa fosse in tick reali o')
w('  OHLC, con che spread, su che finestra di date, con che regola di uscita. Due righe con lo')
w('  stesso PF possono essere una misura seria e una carta straccia. **Il PF qui serve a')
w('  RIAPRIRE un caso, non a promuoverlo.**')
w('- 🔴 **Le date della finestra non sono nei CSV.** Nessuna colonna porta il periodo testato,')
w('  quindi la tabella **non puo\' dire** se un IS rispetta l\'emendamento della finestra')
w('  (>= 150 operazioni, regime dichiarato). Il campo `Trades` e\' l\'unico proxy — ed e\' per')
w('  quello che sta in tabella accanto a ogni PF.')
w('- 🔴 **"Scartato" non e\' una colonna misurabile qui.** I CSV non registrano il verdetto: la')
w('  tabella e\' il censimento di TUTTO cio\' che e\' stato misurato, promosso e scartato insieme.')
w('  Chi e\' stato scartato e perche\' sta nei referti — ed e\' il pezzo che qui, per mandato,')
w('  **non ho letto**.')
w('- 🔴 **`DD%` e `Profit` sono quelli della cella MEDIANA**, non il DD peggiore della corsa.')
w('  Per il criterio di RISCHIO (DD forward > DD promesso) serve il DD della cella')
w('  effettivamente promossa: **quello va ripreso dal CSV grezzo**, riga per riga.')
w('- 🔴 **Nessuna deduplicazione fra cartelle.** La stessa corsa ricopiata in due cartelle')
w('  compare due volte. E\' voluto: la cartella e\' in tabella, cosi\' si vede.')
w('')
w('---')
w('')
w('*Generato il 09/09/2026 su %d CSV di risultati, %d passate valide considerate.*'
  % (stat['csv_usati'], sum((r.get('is_passate') or 0) + (r.get('oos_passate') or 0) +
                            (r.get('unica_passate') or 0) for r in rows)))

out = '/home/user/GITHUB/report/CENSIMENTO_PF_MISURATI_2026-09-09.md'
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'w', encoding='utf-8').write('\n'.join(O) + '\n')
print('scritto', out, os.path.getsize(out), 'byte,', len(O), 'righe')
