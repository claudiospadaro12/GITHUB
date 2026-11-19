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
