# GoldenZoe su EURJPY - criteri scritti PRIMA dei numeri (19/11/2026)

**Domanda:** il vantaggio visto nello scan Market Watch su EURJPY (OOS 2021-24 PF 1,33-1,89 su H1-H8, long-only) e vero, o e solo la salita dello yen debole 2013-24?
**Test:** passata singola per simbolo (non Market Watch, cache OOS troncata), BCM portabile, Modello 1, EURJPY, 5 TF (H1 H2 H4 H6 H8) x IS 2013-20 / OOS 2021-24 x 4 varianti = 40 passate. Solo tester. Stessa EA (878CF3D3...), rischio 1%.
Varianti: **LONG** (base, N=55); **SHORT** (solo short, controllo di deriva); **LONG_N40** e **LONG_N80** (plateau del parametro).

## Previsioni (prima dei dati)
- LONG riproduce lo scan Market Watch entro ±10% su operazioni e PF (controllo tecnico). Se no, lo scan non e affidabile e si ferma.
- SHORT: PF < 1 sulla maggioranza dei TF (probabilita ~70%): EURJPY 2013-24 sale da ~125 a ~160.
- Cautela nota: lo swap short BCM (-16,98 punti/lotto/notte) e applicato costante sul passato (2013-20 tassi JPY ~0 = swap reale molto diverso) e penalizza SHORT. Quindi SHORT e un controllo, non un giudizio.

## Regole di esito (non cambiano dopo)
1. **Riproduzione:** LONG, ogni TF/finestra: operazioni e PF entro ±10% dei valori Market Watch (tabella in `GOLDENZOE_MARKETWATCH_dati/MULTITF_decodificato.json`). Fuori = scan non affidabile.
2. **LONG candidato:** in >=4 TF su 5: IS PF>1,1 e OOS PF>1,2, OOS profitto>0, OOS operazioni>=30. (Soglie piu lasche dell'IS 1,3 dello scan perche e un test di plateau su un'ipotesi gia scelta; non si abbassano ulteriormente.)
3. **Plateau parametro:** LONG_N40 e LONG_N80 devono avere OOS PF>1,1 e profitto>0 in >=3 TF su 5 ciascuno.
4. **Deriva (SHORT):** SHORT OOS PF<0,8 in >=3 TF = deriva confermata -> EURJPY NON validato (vantaggio = tendenza di fondo). SHORT PF>=1,0 in >=3 TF = struttura simmetrica, a favore. Via di mezzo = indeterminato (swap short distorce).
5. **Esito:** "candidato" solo se 1+2+3 passano E la deriva NON e confermata. Se 1+2+3 passano ma deriva confermata: "dipendente dalla tendenza, non validato". Altrimenti chiuso.
6. Anche con "candidato": servono ancora tick reali, correlazione con gli EA di Wim e regole prop prima di qualsiasi forward demo. Nessun consiglio su lotti/taglie.
7. Prove effettuate: 40; il riferimento di confronto e lo scan da 222 prove (rischio selezione).

---
## RISULTATO (19/11/2026, zip GOLDENZOE_EURJPY: 40 passate, dati in `GOLDENZOE_EURJPY_dati/RISULTATI_GOLDENZOE_EURJPY.csv`)
1. **Riproduzione: PASSA.** LONG coincide con lo scan Market Watch (operazioni e PF identici su 10 finestre su 10, es. H2 IS 232/1,32, OOS 134/1,33).
2. **LONG candidato: PASSA 4/5** (PF tester IS / OOS): H1 1,36/1,34; H2 1,32/1,33; H4 1,20/1,39; H8 1,23/1,89; **H6 non passa** (IS 1,07). OOS operazioni 283/134/72/49/37, profitto sempre >0.
3. **Plateau N: PASSA 5/5 per entrambi.** OOS PF N40: 1,21/1,35/1,44/1,13/1,87; N80: 1,27/1,35/1,75/1,34/2,04.
4. **Deriva: CONFERMATA.** SHORT OOS PF 0,73/0,57/0,67/0,65/0,71 (tutti <0,8); SHORT IS 0,95/0,67/0,57/0,91/0,86. Controllo swap (dai report): togliendo lo swap SHORT OOS resta PF 0,82/0,66/0,77/0,78/0,82 (<1 ovunque): non e lo swap. Swap LONG trascurabile (+339..+1060 EUR a TF su 4 anni; PF 1,33-1,87 senza swap).
5. **Esito (regola 5): "dipendente dalla tendenza, NON validato".** La regola specchio perde ovunque dove la LONG guadagna: il vantaggio e la salita di EURJPY 2013-24 (yen debole) catturata dalla regola, non un vantaggio simmetrico. Previsione (SHORT PF<1, ~70%) confermata.
Nota: la LONG e robusta nei parametri e nei TF e riproducibile; e il suo valore futuro dipende da una vista sul regime (yen debole che continua). In demo vale come prova fuori campione; non come EA scorrelato validato.
