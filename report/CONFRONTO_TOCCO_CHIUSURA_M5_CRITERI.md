# Confronto tocco / chiusura M5 (Nasdaq) — criteri congelati PRIMA dei numeri

**Stato: costruito, NON lanciato, NON mandato a Claudio (30/09/2026).** Aspetta il cancello di giudizio.
Strumento: `backtest_pipeline/confronto_tocco_chiusura_m5.py` (marcatore `MARCATORE_CONFRONTO_TOCCO_CHIUSURA_M5_v1`, commit pin `747856b1413c5a575038f127ffb4bd0c3d2f19de`, SHA256 `2B7272820CCBA86C9012DE94BF8E6783008A4EB91AD4F201D8A3077653F30CB0`).
Riga di lancio: `backtest_pipeline/righe/RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt` (bersaglio: **finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ**, nessun terminale MT5 toccato).
Fonte della domanda: `report/ANALISI_LIVE_PAOLO_2026-09-29.md` par. 2 punto 1 (righe 57 e 91 della trascrizione: «si entra quando una candela M5 chiude oltre la linea del box»).

## 1. La domanda (una sola)

Sul Nasdaq, entrare quando una candela M5 **chiude** oltre il range d'apertura (primi 15 minuti dopo le 09:30 di New York; e, in un secondo blocco, i primi 30) e' **meglio o peggio** che entrare al **primo tocco** del livello, come fanno i nostri motori con l'ordine pendente?

Solo Nasdaq. Il DAX non e' misurabile col feed HistData (vedi il referto dell'anatomia). Feed esterno: uso D-C = **SOLO_PROVA_REGIME**. Nessun PF, nessuna equity, **nessun costo**: ogni R e' LORDO. Una frequenza non e' un edge.

## 2. Definizioni (identiche all'anatomia dove esistono)

| Voce | Definizione |
|---|---|
| Giorno valido | stesso cancello dell'anatomia (stato OK: copertura oraria, buchi, banda di prezzo) |
| Range | prime N minuti dell'apertura cash (N = 15 e 30), dalle M5 costruite dalle M1; calibrazione dell'ora d'apertura dell'anatomia |
| Stop | bordo OPPOSTO del range, in tutte e due le entrate |
| ENTRATA A | prima barra M5 con offset >= N il cui estremo tocca il livello (buffer 0): la «prima rottura» dell'anatomia, **riprodotta giorno per giorno**. Barra che tocca i due lati = AMBIGUA, nessuna entrata A |
| ENTRATA B | prima barra M5 con offset >= N la cui **chiusura** e' strettamente oltre il livello; entrata al close di quella barra. Peggiore per ritardo e per prezzo: dichiarato |
| R' | distanza entrata-stop. A: ampiezza del range. B: close d'entrata meno stop (sempre piu' grande) |
| Esito | sequenza sulle barre M5 fino a fine seduta: +1R' prima dello stop (T), stop prima (S), nessuno (N). Barra con bersaglio e stop = A (ambigua). Funzione `_sequenza` **importata** dall'anatomia; per B le barre contano dalla successiva a quella d'entrata |
| R lordo | T*(+1) + S*(-1) + N*0, ambigue come stop; SENZA costi. Seconda lettura «a mercato»: i N chiusi al close dell'ultima barra. Forchetta dell'ambiguita' stampata |
| Falso | una delle prime 3 chiusure M5 dopo l'entrata e' <= al livello. A: barre kA..kA+2 (e' il «falso entro 15 min» dell'anatomia, riprodotto). B: barre kB+1..kB+3 |
| Coppie | giorni con A e B dello STESSO lato. Si contano a parte: lati opposti, SOLO A (B non entra mai), SOLO B (A ambigua) |
| Fasi | addestramento 2010-2020 (le soglie si pronunciano SOLO qui; un solo regime) e cassaforte 2021-2026 (valida soglie gia' congelate), in **referti distinti** |

Importante: l'anatomia e' **importata, non copiata e non modificata**. Lo script controlla lo SHA256 dei due file dell'anatomia contro il pin (`EFD839E2...` e `446D2D18...`), li aggancia (`Gancio`) solo per la durata della corsa e rimette l'originale (verificato dall'autotest, anche dopo un'eccezione).

## 3. Cosa ho letto prima di scrivere le soglie (dichiarato)

Dal referto dell'anatomia **dell'addestramento** (`risultati_archivio/ANATOMIA_MOVIMENTI_M5_2026-09-29/NASUSD/..._IS_2010_2020.txt`) ho letto SOLO la colonna dell'entrata A. **La cassaforte dell'anatomia NON e' stata aperta.** Il B non l'ho mai visto: non esiste nessun numero di B.

Tre fatti letti, che hanno dettato il metodo:
- l'R lordo di A e' **gia' ~0**: da T e S a +1R (IS) esce -0,019 (LONG 15), -0,014 (SHORT 15), -0,029 (LONG 30), +0,047 (SHORT 30). Non c'e' molto da migliorare, e nemmeno da peggiorare;
- la barra del tocco chiude DENTRO il livello nel **46,8-49,0%** dei casi: per costruzione, in quei giorni B non puo' entrare sulla barra del tocco;
- il «falso entro 15 minuti» di A e' 66,9-70,2%.

### Bersagli di riproduzione (valori dell'anatomia IS, che questo strumento DEVE ritrovare per A)

| Range / lato | n | T % | S % | A % | N % | barra del tocco chiude dentro % | falso15 % (n) | B sulla stessa barra (identita') |
|---|---|---|---|---|---|---|---|---|
| 15 LONG | 1267 | 42,5 | 44,4 | 0,0 | 13,0 | 46,8 | 66,9 (1267) | 674 |
| 15 SHORT | 1214 | 45,3 | 46,7 | 0,0 | 8,0 | 48,0 | 70,2 (1213) | 631 |
| 30 LONG | 1348 | 33,8 | 36,7 | 0,0 | 29,5 | 49,0 | 68,7 (1347) | 687 o 688 |
| 30 SHORT | 1135 | 42,4 | 37,7 | 0,0 | 19,9 | 46,7 | 69,8 (1132) | 605 |

L'ultima colonna e' l'**identita'**: B sta sulla stessa barra del tocco se e solo se quella barra chiude fuori dal livello, quindi «B sulla stessa barra» = n x (1 - quota dentro). Il referto la stampa (`identita': A con la barra del tocco che chiude FUORI = X; B sulla STESSA barra del tocco = Y`) e X e Y devono coincidere. Se A non riproduce questi numeri il pin non e' quello giusto o il feed e' cambiato. In corsa, lo strumento confronta A con la «prima rottura» dell'anatomia **giorno per giorno** (lato, minuto, sequenza +1R, falso15, chiude dentro) e verifica le identita' fra A e B: una sola differenza = **rc 2, nessun referto** (confronto invalido).

## 4. Le due ipotesi (NON esaustive, NON esclusive)

- **H_CHIUSURA (meccanismo)**: la chiusura M5 filtra i falsi breakout: fra le entrate di B c'e' una quota di falsi minore che fra quelle di A.
- **H_NIENTE (pagamento)**: B paga solo il ritardo: R lordo B <= R lordo A.

Possono valere insieme: la combinazione «filtra ma non paga» e' un esito, non una contraddizione.

## 5. Perche' il confronto grezzo non e' un test (classe 178) — tre contro-esempi, misurati

**5.1 Il falso.** «Falso% di B < falso% di A di X punti» cade **anche senza nessuna informazione**: B entra a una distanza d > 0 oltre il livello, A entra esattamente sul livello, e su un cammino casuale il ritocco del livello nelle 3 chiusure successive e' piu' probabile da d = 0. Misurato nell'autotest su un random walk con profilo orario tipo Nasdaq (12 semi x 2 lati = 24 celle, ~700-750 entrate per lato): divario grezzo A-B = **16,2-22,9 punti (media 19,7)** con ZERO informazione. Una banda «B meno di A di 10 punti» sarebbe passata sempre.

**5.2 La selezione sulle coppie.** Sulle coppie (stessi giorni, A e B dello stesso lato) A e' avvantaggiata per costruzione: i giorni in cui B esiste sono quelli in cui il prezzo ha poi chiuso fuori, dopo l'entrata di A e prima di quella di B. B-A esce negativo anche in un mercato senza memoria (nel mondo sintetico senza memoria: da -0,09 a -0,22 a seconda del range). E le coppie **non vedono il filtro**: i giorni in cui B non entra non ci sono.

**5.3 La potenza a soglia 0,05.** Con un errore standard dell'eccesso R di 0,033 (misurato a n ~750 per lato), la soglia 0,05 richiede eccesso <= +0,001 per dire «NO»: nel mondo senza memoria il test riesce a confermare H_NIENTE solo in **4 celle su 24**. Una banda che non puo' cadere dove cade l'ipotesi vera non e' un test.

## 6. Il metodo che ne esce

**Il nullo.** Giorni surrogati: il range e' quello vero; ogni barra successiva ha il **segno tirato a sorte** (barra specchiata attorno alla sua apertura), con la stessa ampiezza, la stessa forma, lo stesso profilo orario e gli stessi buchi. Direzione senza memoria = H_NIENTE per costruzione. K = 30 surrogati per giorno-range, seme fisso 20260930. **ECCESSO = osservato - media del nullo**, per il falso e per l'R.

**Due confronti.** COPPIE (quello chiesto: stessi giorni; errore standard di coppia) e ENTRATE (tutte le entrate di A contro tutte quelle di B per lato, sugli stessi giorni validi; errore standard per giorno con il metodo delta, giorni sovrapposti). Il **meccanismo** si giudica sulle ENTRATE (dove il filtro si vede). Il **pagamento** deve valere su tutti e due, altrimenti INCONCLUSIVO. Il nullo e' calcolato con le stesse regole per tutti e due.

**Soglie (congelate):**

| Soglia | Valore | Perche' |
|---|---|---|
| X_F, eccesso sul falso | **10 punti percentuali** | errore standard dell'eccesso ~2 punti (IC95 ~4): 10 sta oltre 2 IC; ordine di grandezza a cui un filtro cambia il mix di trade. Contro-esempio: nel mondo senza memoria l'eccesso misurato sta in [-3,2 ; +5,2] su 24 celle, mai vicino a 10, mentre il divario grezzo (5.1) lo supera sempre |
| X_R, eccesso sull'R lordo e a mercato | **0,08 R'** | errore standard ~0,033 a n ~750 (misurato), ~0,025 attesi a n ~1250 (stima 1/radice(n), non misurata). A 0,08 il test conferma H_NIENTE in **15 celle su 24** (contro 4 a 0,05) con **0 falsi «PAGA» su 24** (con tutte e due le soglie). E' dello stesso ordine di 1 punto di spread su un R' di 15 punti (0,067 R; spread NON MISURATO): un eccesso minore non pagherebbe un costo di quell'ordine |
| n minimo per cella | **150** (coppie; min(entrate A, entrate B)) | Emendamento A: l'unita' e' l'operazione-giorno, >= 150 |
| Intervallo | IC 95% (1,96 errori standard; l'errore dell'eccesso somma quello osservato e quello della media del nullo) | |

**Zona di una misura:** SI se eccesso >= soglia e limite basso dell'IC > 0; NO se il limite alto dell'IC < soglia; INCERTO negli altri casi.
- MECCANISMO: FILTRA = eccesso sul falso in zona SI (entrate); NON_FILTRA = zona NO.
- PAGAMENTO: PAGA = eccesso R e eccesso R a mercato in zona SI, su coppie **e** entrate; NON_PAGA = zona NO su tutte; altrimenti INCONCLUSIVO.

**Lettura di una cella** (LONG o SHORT di un range):

| Meccanismo | Pagamento | Lettura |
|---|---|---|
| FILTRA | PAGA | H_CHIUSURA sostenuta (filtra e paga, AL LORDO) |
| NON_FILTRA | NON_PAGA | H_NIENTE sostenuta |
| FILTRA | NON_PAGA | filtra ma il ritardo se lo mangia |
| NON_FILTRA | PAGA | ANOMALIA da guardare a mano (non e' H_CHIUSURA) |
| qualsiasi altro / n < 150 | | INCONCLUSIVA / NON GIUDICABILE |

Un **range** (15 o 30) ha una lettura **solo se LONG e SHORT dicono la stessa cosa**; altrimenti INCONCLUSIVA. I verdetti dell'addestramento decidono; la cassaforte li conferma o no (il referto della cassaforte stampa cella per cella CONCORDE / DISCORDE). Sono verdetti su una **descrizione**, non promozioni. «NON_PAGA» non vuol dire «B strettamente <= A»: vuol dire «nessuna evidenza di un vantaggio >= 0,08 R'». La stima puntuale e' sempre stampata.

**Il mondo con la risposta** (controllo dell'autotest, 12 semi x 2 lati): mondo in cui la chiusura porta informazione (45% rotture vere, 45% trappole a stoppino, 10% rumore) -> PAGA 24/24, FILTRA 22/24 (gli altri due INCONCLUSIVO, con eccesso 9,0 e 9,4: sotto la soglia, non oltre).

**Attesa di chi scrive (NON un criterio, scritta prima dei numeri):** NON_PAGA o INCONCLUSIVO in quasi tutte le celle (l'R lordo di A e' gia' ~0, quello di B non ha motivo di stare sopra); il meccanismo puo' mostrare un eccesso piccolo. Se esce il contrario e' una notizia da ricontrollare a mano prima di crederci. Chi legge dovrebbe gia' aspettarsi molti «INCONCLUSIVA»: con eccessi vicini a zero e errore ~0,025 la soglia 0,08 non si conferma ne' si smentisce sempre.

## 7. Cosa NON si potra concludere (dichiarato prima)

- **Nessun PF, nessuna equity, nessun costo.** «PAGA» = B batte A **al lordo**, non «B guadagna». Cella con R' mediano di 15 punti: la frontiera `stop >= 40 x spread` ammette solo spread <= 0,375 punti [spread Nasdaq BCM: NON MISURATO qui].
- **D-C = SOLO_PROVA_REGIME**: feed HistData esterno, non BCM. Nessun parametro, nessuna sedia, nessuna promozione esce da qui; ogni valore e' un'ipotesi da misurare nel tester BCM a tick reali.
- **Un solo regime nell'addestramento** (2010-2020, lunga salita con tassi a zero): la lettura vale per quel regime (Emendamento A: regime dichiarato). La cassaforte 2021-2026 contiene un altro regime, ma 2023 ha il 33,2% di giorni sospetti nel feed (log dell'anatomia): ha meno giorni buoni.
- **Asimmetria a favore di A**: l'entrata A e' «al livello» (fill ideale di un pendente, anche se la barra del tocco lo ha attraversato con un salto); B paga il close reale. Un B <= A puo' dipendere in parte da questo, non solo dal ritardo.
- Il close come prezzo d'entrata ignora slippage e gap fra close e open successivo; l'ordine dentro una barra M5 non e' osservabile.
- Otto celle (2 range x 2 lati x 2 fasi) = otto occasioni di rumore: per questo la soglia e' un eccesso con IC, un range vale solo se LONG e SHORT concordano, e decide l'addestramento.
- Il nullo e' UN modello di H_NIENTE (segni casuali barra per barra): non copre memoria di volatilita' ne' code. Vicino alla soglia la risposta e' INCERTO, non SI. Se l'IC95 dell'eccesso e' piu' largo della soglia, la cella e' dichiarata «non risolvibile» (rilievo, rc 1).
- Niente sul DAX, sul retest, o su uscite diverse da +1R'.

## 8. Come leggere il referto (5 passi)

1. `ESITO` e i **RILIEVI** in fondo; rc 2 = invalido.
2. «RIPRODUZIONE DELL'ANATOMIA» di ogni range: A deve tornare alla tabella del par. 3; l'identita' X = Y deve tornare.
3. Contabilita' dei giorni: quanti SOLO A (le entrate che la chiusura filtra), quanti lati opposti.
4. Per ogni lato: tabelle coppie e entrate, decomposizione S (stessa barra: pura perdita di prezzo) / L (barra dopo: il filtro).
5. «VERDETTO MECCANICO DELLA CELLA»: eccessi con IC, zona, lettura. **Non citare mai il divario grezzo del falso.**

## 9. Controlli fatti (30/09/2026)

- `python3 backtest_pipeline/confronto_tocco_chiusura_m5.py --autotest` -> **AUTOTEST: 210/210**: (0) SHA256 dell'anatomia = pin, file non cambiati, gancio reversibile anche dopo eccezione, nessuna funzione dell'anatomia copiata; (1) casi a risposta calcolata a mano: tocca senza chiudere fuori, chiusura fuori sulla stessa barra del tocco, chiusura una barra dopo (A vince prima, B stoppata), specchio long/short, barra ambigua a due lati (con e senza chiusura fuori dopo), giorno senza rottura, range degenere, lati opposti, bersaglio e stop nella stessa barra, entrata sull'ultima barra, chiusura esattamente sul livello, falso visibile solo alla terza chiusura, bersaglio di B toccato nella barra d'entrata (non conta), bersaglio a +1 R' e non a +1 ampiezza, buchi, range di 15 minuti; invarianti A/B su tutti i casi; (2) surrogato; (3) statistiche a mano e confini delle zone; (4) verdetto ai confini esatti; (5) **fuzz**: 1400 giorni-range casuali (con buchi) attraverso l'anatomia **vera**, differenze 0; (6) i due mondi sintetici; (7) corsa vera su un CSV sintetico (due referti distinti, ASCII, niente PF, rifiuti rc 2, incoerenza con l'anatomia -> rc 2 e nessun referto); (8) **9 mutazioni catturate su 9** (`>=` al posto di `>`, falso di B dalla barra d'entrata, sequenza di B dalla barra d'entrata, bersaglio a +1 ampiezza, falso di A spostato, surrogato senza segni, tre soglie).
- `python3 backtest_pipeline/controlla_riga.py --oggetto riga backtest_pipeline/righe/RIGA_CONFRONTO_TOCCO_CHIUSURA_M5.txt` -> vedi par. 10.
- **Collaudo della riga eseguita** sotto pwsh con ambiente finto (`backtest_pipeline/collaudo_riga_confronto_tocco/collaudo.py`, classe 926: la riga si esegue, non si legge): 10 scenari (sano; macchina sbagliata; marcatore mancante; SHA256 diverso su anatomia e su confronto; CSV assente; CSV nel formato sbagliato; autotest del confronto che fallisce; autotest dell'anatomia che fallisce; misura che esce 2 con file mancanti ma zip creato).
- Il gancio, il file dell'anatomia e la riga sono committati e pushati su `lavoro`.

## 10. Tempo

**[NON MISURATO]** su questo CSV con questo script. Riferimenti, entrambi indiretti: (a) la corsa dell'anatomia sullo stesso CSV (Nasdaq 5,23 milioni di righe piu' DAX piu' autotest) parte dal nome della cartella (`..._20260929_1734`, ora locale) e il suo archivio e' committato alle 15:40:57 UTC del 29/09: al massimo circa 7 minuti in tutto (inferenza sugli orologi, non un tempo misurato); (b) su un CSV sintetico di 700 giorni (273.000 righe) l'anatomia da sola impiega ~1,4 s e questo script ~4,2 s con K = 30: il costo in piu' e' ~4 ms per giorno, ~20 s su 4000 giorni. Sul PC di backtest, piu' lento di questa macchina, ci si aspetta una corsa in **pochi minuti**; RAM ~28 MB sul sintetico [sul CSV vero NON misurata].

## 11. Punti aperti per il cancello di giudizio

1. Le soglie X_F = 10 e X_R = 0,08 sono un **giudizio** (con i contro-esempi sopra), non una legge: vanno lette col loro ragionamento.
2. Il nullo a segni casuali e' un solo modello di H_NIENTE.
3. Il verdetto sul pagamento chiede coppie **e** entrate: e' piu' severo di quanto chiesto («stessi giorni»), scelto perche' le sole coppie non vedono il filtro (5.2).
4. Timeout a 0 come lettura primaria (come da richiesta), con la lettura a mercato a fianco e l'obbligo di concordanza.
5. Non so quanti saranno i giorni SOLO A sul feed vero: se pochi, il «filtro» sara' quasi tutto nella sottoclasse L.
