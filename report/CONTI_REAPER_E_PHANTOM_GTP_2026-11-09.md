# Due conti: Reaper da solo + (Phantom e Gold Trade Pro insieme), e come dividere il capitale (09/11/2026)

**Richiesta di Claudio**: conto A = solo Gold Reaper; conto B = Gold Phantom + Gold Trade Pro; due da 80k oppure 160k + 80k. **Natura: stima da backtest**, non consiglio di lotto (i lotti sono quelli dei set). Dati: tester BCM, 80k, anni 2013, 2018, 2020, 2025 (4 anni), commissioni+slippage FTMO "centrale" (36 EUR/lotto oro), P&L giornaliero REALIZZATO, Randomization 50 su Reaper e Phantom (rumore). Scalatura a 160k: x2 (D160: oro e GTP 2,0-2,17, `RISULTATI_D160_ORO_2026-11-09.md`). Script: `ORO_GRADINI_dati/conti_reaper_phantom_gtp.py` e `alloc_conti.py`; dati `conti_reaper_phantom_gtp.json`.

## Per conto, a 80k (la % vale a qualsiasi taglia)
| Conto | Set | Netto/anno (2013/2018/2020/2025) | Media | Peggior giorno per anno | Giorni <= -4,3% (<= -5%) in 4 anni | DD realizzato massimo | Limite sup. DD equity (somma EA) | Sfida entro 180 gg: fase 1 passata / bocciata per regola / ancora aperta; fasi 1+2 |
|---|---|---|---|---|---|---|---|---|
| A | Reaper L0 (Gold_reaper_propfirm) | 14.222 / 5.689 / 17.729 / 32.317 | 17.489 | -6,0 / -2,8 / -2,1 / -1,3% | 2 (2) | 9,1% (2013) | 8,5% | 49% / 7% / 45%; 38% |
| A | Reaper L1 (15%maxrisk) | 25.908 / 2.871 / 23.921 / 49.261 | 25.490 | -9,7% nel 2013 | 5 (4) | 15,2% | 13,9% | 61% / 13% / 26%; 43% |
| A | Reaper L3 (Combo 3GOLD) | 1.739 / 1.489 / 5.432 / 7.893 | 4.138 | -1,6% | 0 | 3,9% | 3,8% | 0% passata (tutto aperto) |
| B | Phantom L1 + GTP Combo | 17.903 / 6.046 / 12.915 / 26.843 | 15.927 | -3,8 / -2,6 / -1,9 / -1,3% | 0 | 8,8% (2013) | 9,2% | 46% / 0% / 54%; 28% |
| B | Phantom L0 + GTP Combo | 15.652 / 5.107 / 8.098 / 15.300 | 11.039 | -3,3% | 0 | 6,2% | 7,2% | 24% / 0% / 76%; 15% |
| B | Phantom L3 + GTP Combo | 15.767 / 5.515 / 8.432 / 15.599 | 11.328 | -3,4% | 0 | 6,2% | 7,1% | 24% / 0% / 76%; 14% |
Le finestre di sfida sono sovrapposte (circa 550-650 per conto) e vengono da 4 anni: non sono probabilita indipendenti.

## Letture
- **Reaper da solo e il conto delicato.** Al livello Prop supera il -5% in due giorni (2013) e arriva al 9,1% di DD realizzato: vicino al limite del 10%. Il Gradino 1 (15%maxrisk) e fuori limite. Il Combo 3GOLD e troppo piccolo per una sfida (4,1k/anno). Manca un livello intermedio: come **scenario** (NON consiglio di lotto) il Prop a 0,7 volte il lotto porterebbe il peggior giorno a -4,2% e il netto medio a 12.242/anno a 80k. Il Guardian a -4,3% chiuderebbe i giorni peggiori (ma nel tester puo includere artefatti).
- **Phantom + GTP e il conto solido**: nessun giorno <= -4,3%, nessuna bocciatura per regola nelle finestre; il Gradino 1 rende di piu ma ha il limite superiore del DD al 9,2% (2013).
- **Correlazione**: i giorni dei due conti sono correlati 0,54-0,84 (tutto oro): nei giorni neri perdono insieme. 2013 e l'anno peggiore (oro -27%).

## Come dividere il capitale (conto A = Reaper L0 pieno, B = Phantom L1 + GTP Combo; netto lordo/anno, media 4 anni)
| Assetto | Capitale | Netto/anno | A / B | Peggior giorno congiunto (anno peggiore 2013) | DD realizzato congiunto 2013 |
|---|---|---|---|---|---|
| A 80k + B 80k | 160k | 33.416 | 17.489 / 15.927 | -7.301 (-4,56%) | 8,0% |
| A 160k + B 80k | 240k | 50.905 | 34.978 / 15.927 | -11.939 (-4,97%) | 7,7% |
| **A 80k + B 160k** | 240k | 49.343 | 17.489 / 31.853 | -10.042 (-4,18%) | 8,3% |
Con il Reaper a 0,7 (scenario): 80+80 = 28.169; 160+80 = 40.411; 80+160 = 44.096.
Con B al livello Prop (piu prudente): 80+80 = 28.528; 160+80 = 46.017; 80+160 = 39.567.
- **La taglia scala solo gli euro**: le regole FTMO sono in % del singolo conto, quindi la probabilita di sfida di A e B non cambia con la taglia.
- **Differenza 160+80 contro 80+160: circa 3% del netto** (50.905 contro 49.343), ma nel primo il conto con piu bocciature (il Reaper: 7% di finestre fallite per giorno -5%, peggior giorno -6%) e quello con la quota piu alta e il capitale piu grande. Per questo preferisco l'assetto con la taglia grande sul conto solido (B) e la piccola sul Reaper.
- **Tetto 320k EUR**: 240k lascia 80k di margine; due da 80k ne lasciano 160k. Il tetto e la domanda in sospeso verso FTMO (somma con altri utenti, EA diversi).

## Limiti dichiarati
4 anni, un percorso per anno, rumore Randomization 50 (O-3b: 6-46% sul Reaper), P&L realizzato (l'equity intragiornaliera non e ricostruita; "limite sup." e la somma dei massimi dei singoli EA), nessun forward, margine e leva dell'oro su FTMO NON verificati, lotti del tester, nessun consiglio di lotto o taglia. Il livello intermedio del Reaper e uno scenario di scala lineare, non un set di Wim.
