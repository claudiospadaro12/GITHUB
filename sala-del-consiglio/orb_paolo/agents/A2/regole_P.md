# A2 - Trascrizione delle regole ORB "Metodo Paolo" (R001)

Fonte unica: `materiali/ORB_Metodo_Paolo.pdf` (14 slide, letto con pdftotext per pagina + controllo visivo delle slide 5, 6, 7, 9, 10). La bozza P01-P12 di C0 nel brief NON e stata usata come fonte: ho ritrascritto dal PDF e poi confrontato (sezione 5). Nessun backtest, nessun dato toccato.

## 0. Mappa delle slide (numero di pagina del PDF)
1 Copertina (chip: BOX 15 MIN / CANDELA M5 / TP 1:1) - 2 L'idea - 3 Il metodo in 9 passi - 4 Quando (Nasdaq sera / DAX mattina) - 5 Il box (31 vs 100+) - 6 La candela di ingresso - 7 Il contesto - 8 Prima di entrare (resistenze, distanza) - 9 Un trade tipo (schema) - 10 Ingresso, stop, target - 11 Money management - 12 Cosa evitare - 13 Come studiarla - 14 Chiusura ("la cornice, il disegno e tuo").

## 1. Criteri di classificazione usati
- **OGGETTIVA**: ogni elemento e definito nel PDF in modo calcolabile; nessun parametro libero da inventare.
- **PARZIALE**: il nucleo e misurabile, ma nel PDF manca almeno un parametro/definizione (soglia, indicatore, tolleranza, unita). Si codifica solo scegliendo un valore che NON e di Paolo.
- **DISCREZIONALE**: dipende dal giudizio visivo/soggettivo del trader ("bell'inclinato", "a ridosso", "tecnico", "a mano"); anche con un parametro la definizione sarebbe una nostra invenzione.
- **NON NEL PDF**: elemento che serve per codificare ma il PDF non dice.
- Le citazioni sono dal PDF; gli orari sono ora italiana (il PDF non lo dice esplicitamente ma i 15:30 sono ora IT: slide 2, 4). Conversione in ora server BCM: vedi CLAUDE.md di progetto (non e materia del PDF).

## 2. Tabella delle regole (P01-P12, con sotto-regole)

| ID | Slide | Regola trascritta (citazione breve) | Classe | Motivo | Parametro che servirebbe per renderla oggettiva |
|---|---|---|---|---|---|
| P01a | 1, 3, 4 | Box = primi 15 minuti. Nasdaq 15:30-15:45. «Box 15 min» | OGGETTIVA (con assunzione) | Finestra oraria fissa. Ma come si ricava il box (high/low delle candele? includendo le ombre?) NON NEL PDF: si assume massimo/minimo della finestra | Esplicitare: box = max/min (con ombre) su dati M1 o tick nella finestra |
| P01b | 4 | Indicatore: 15:30-15:44:59, «se no vi prende anche la candela successiva» | OGGETTIVA | La finestra esclude 15:45:00. Conferma che il box e [15:30, 15:45) | nessuno |
| P01c | 3, 4 | DAX: box «all'apertura del mattino» / «Apertura europea». Lunghezza del box DAX non scritta (15 min solo implicita dal chip slide 1) | PARZIALE | Orario di apertura DAX NON NEL PDF; durata 15' per il DAX NON NEL PDF in modo esplicito | Orario di apertura DAX usato (ora IT e ora server) e durata del box DAX |
| P01d | 4 | Ora legale: «per la mattina e uguale; la sera, finche l'America non cambia ora, si apre alle 14:30 invece che alle 15:30» | OGGETTIVA (calendario) | Regola di calendario chiara. Il PDF cita solo il caso «finche l'America non cambia ora» (autunno); il caso primaverile NON NEL PDF in modo esplicito | Calendario esplicito delle settimane di scarto USA/Europa per anno |
| P01e | 2 | «Dopo almeno 15 minuti. Non prima.» (liquidita alle 15:30, il mercato si stabilizza e poi prende una direzione) | OGGETTIVA | Nessun ingresso prima della chiusura del box (prima candela utile M5 dalle 15:45). «Almeno» lascia aperto se il box possa essere piu lungo: lettura prudente = 15 | nessuno (assumere 15) |
| P02a | 3, 6 | Candela M5 che «apre e chiude fuori dal box» | OGGETTIVA (con assunzione) | Open e close oltre lo stesso lato del box. «Fuori» = stesso lato e tolleranza 0 sono assunzioni nostre; lo schema slide 6 mostra la candela tutta fuori | Confermare: open e close strettamente oltre lo stesso bordo |
| P02b | 6 | «Gli spike non contano»; candela col corpo «piccolino» che ha solo «breccato» non si considera | PARZIALE | Escludere le ombre e automatico con P02a. Ma «corpo piccolino» non ha soglia, e se open e close sono entrambi fuori il caso «piccolino» e gia incluso da P02a: possibile contraddizione | Corpo minimo (punti, % del box o ATR) e/o chiusura minima oltre il bordo |
| P02c | 6 | «Se fosse stata verde uno poteva farci una riflessione» (esempio short con candela rossa) | DISCREZIONALE | Il colore conta in modo non quantificato: «riflessione» = giudizio, non regola | Colore concorde obbligatorio si/no; altrimenti nessuna regola |
| P02d | - | Quale candela M5 vale (solo la prima dopo il box o una qualsiasi), finestra massima di ingresso, entrambi i lati, riarmo dopo un falso breakout | NON NEL PDF | Il PDF non dice nulla | Ora limite ingresso; solo-prima-candela si/no; numero max trade/giorno |
| P03a | 3, 7 | Medie «ordinate nella direzione del trade». Nel retest: chiusura «sopra tutte le medie» | PARZIALE | Quali medie, periodi e tipo NON NEL PDF | Elenco medie (tipo, periodo, TF) e criterio di ordine |
| P03b | 3, 7 | SuperTrend «rotto e "bell'inclinato" a favore» | PARZIALE | «Rotto» e calcolabile (stato/flip del SuperTrend). «Bell'inclinato» e giudizio; parametri SuperTrend NON NEL PDF | ATR period e moltiplicatore, TF, pendenza minima (punti/barra) |
| P03c | 3, 7 | Volumi «alti sulla rottura», ma «servono solo per migliorare il contesto» | DISCREZIONALE (e dichiarato NON filtro) | Il PDF stesso dice che non e un requisito | Se mai: volume della candela / media N barre >= k |
| P03d | 7 | VWAP: «Guardato a favore nell'esempio di retest» | PARZIALE | Citato solo nell'esempio di retest, non come regola generale; ancoraggio/sessione NON NEL PDF | Ancoraggio (apertura sessione) e se vale solo nel retest |
| P03e | 7 | Trend «sempre a favore, "secondo come ho battezzato il mercato la mattina"» | DISCREZIONALE | Definizione del trend = lettura soggettiva della mattina | Definizione operativa di trend (es. posizione vs chiusura precedente/VWAP, pendenza medie su TF alto) |
| P03f | 7 | «Da valutare: direzioni delle medie, imbalance, cross, SuperTrend, livelli tecnici» | DISCREZIONALE | Elenco senza parametri; «cross» non specificato (quali medie?) | Definizioni di cross/imbalance/livello |
| P03g | 3, 7 | Se il contesto sia filtro obbligatorio o solo lettura; quanti elementi servono | NON NEL PDF | Titolo slide 7 «Cosa guardare», colonna «Cosa dice Paolo»; slide 3 lo mette come passo 3 ma senza regola di punteggio/soglia | Regola esplicita: quali condizioni obbligatorie, quante almeno |
| P04a | 8 | «Non si entra mai a ridosso di una resistenza» H1/H4 | DISCREZIONALE | Livelli H1/H4 scelti a vista; «a ridosso» senza distanza | Algoritmo livelli (swing N barre su H1/H4) + distanza minima (punti, ATR o R) |
| P04b | 8, 12 | Si aspetta la rottura della resistenza e «si entra sulla candela successiva» | PARZIALE | «Rottura» (chiusura oltre il livello?) e «candela successiva» plausibili ma non definiti | Criterio di rottura (chiusura M5 oltre livello + tolleranza) |
| P04c | 8 | Lo stop resta «dall'altra parte»: «entri con una size piu piccola, tieni conto della distanza» | PARZIALE | Stop = bordo opposto del box (oggettivo, vedi P06b). La riduzione di size NON ha misura nel PDF | Fattore di riduzione (fuori perimetro: niente taglie) |
| P04d | 8 | «Preferisco perdere l'operazione ma non prendermi il drawdown» | DISCREZIONALE | Dichiarazione di atteggiamento, non regola codificabile | nessuno (non regola) |
| P05a | 8, 12 | «Se apri troppo lontana non e consigliabile entrare» | PARZIALE | Distanza misurabile, ma soglia e cosa si misura (distanza dal bordo? dimensione candela? chiusura?) NON NEL PDF; strumento degli esempi non dichiarato | Distanza max dal bordo del box (punti per strumento, o % del box / ATR) |
| P05b | 8 | Esempi della call: «35 punti con rifiuto da resistenza, 41 con molta imbalance, 53 "si abbandona"» | PARZIALE | Sono esempi, NON soglie. Il PDF non dice quale dei tre sia sopra o sotto la soglia, tranne 53 = abbandono | Soglia di skip (punti) e soglia di attesa-retest, per strumento |
| P05c | 8, 12 | «Con molta imbalance il prezzo verosimilmente torna indietro» | DISCREZIONALE | «Imbalance» non definita | Definizione (es. rapporto corpo/range, gap tra candele, FVG) |
| P05d | 7, 8 | Se troppo lontana: si aspetta il «retest rifiutato» e si entra alla chiusura (retest: chiusura «sopra tutte le medie», VWAP a favore) | DISCREZIONALE | «Retest» e «rifiutato» non definiti (tocco del bordo? tolleranza? tipo di candela?), attesa massima non scritta | Tolleranza di tocco, pattern di rifiuto, numero max barre di attesa |
| P06a | 3, 10 | Ingresso «alla chiusura della candela» | OGGETTIVA | Market alla chiusura M5 della candela valida | nessuno |
| P06b | 3, 9, 10 | Stop «lato esterno opposto del box, "un gocciolino fuori"» | PARZIALE | Bordo opposto oggettivo; «gocciolino» senza misura | Buffer oltre il bordo (punti o tick/spread) |
| P06c | 12 | Stop troppo stretto da evitare: «messo sulla candela da 5 minuti precedente, ti fa uscire dal trade» | PARZIALE | Divieto di uno stop sull'ultima candela M5; ma con P06b lo stop e gia al bordo opposto: la regola vale forse solo per ingressi al retest. «Troppo stretto» senza soglia | Stop minimo (punti o ATR) |
| P07a | 5 | Box stretto meglio di box largo: «31 punti» = «bell'ORB» («rischio-rendimento molto vantaggioso»), «100+ punti» = «piu complesso» | PARZIALE | Dimensione del box e misurabile; soglia di esclusione NON NEL PDF («piu complesso» non e vietato) | Dimensione max box (punti, % range giornaliero o ATR D1) |
| P07b | 5, 12 | «Un 1:4 con lo stop a 120 punti "non lo fai mai"», perche «superiore alla volatilita media» (DAX: «295 punti di range giornaliero») | PARZIALE | Cosa e «superiore» (stop? target 480?) ambiguo; soglia vs volatilita non data | Stop/target massimo come frazione del range medio giornaliero |
| P08a | 1, 3, 10 | Take profit «1:1 - "sono conservativo"» | OGGETTIVA | TP = 1R dallo stop (distanza ingresso-stop). Vedi ambiguita con P08b/P08c | nessuno |
| P08b | 3, 9, 10 | TP «tecnico» sui livelli | DISCREZIONALE | Livelli a vista; non e chiaro se sostituisca o affianchi l'1:1 (NON NEL PDF) | Algoritmo livelli + regola di priorita tra 1:1 e livello |
| P08c | 3, 9, 10 | Parziale: «50% prima che il prezzo arrivi sulla resistenza (DAX: 30-40 punti)»; «Intorno a 40 punti parzializzo» | PARZIALE | Il 50% e fisso. Il trigger e doppio (resistenza o 30-40 punti) e «intorno» non e un numero; Nasdaq NON NEL PDF | Trigger unico (punti fissi per strumento, o R) e valore |
| P08d | 10 | Dopo il parziale: «Stop in pari, piu un euro: "non mi piace vedere zero"» | PARZIALE | Meccanica chiara; l'unita «un euro» e ambigua (1 euro di P&L, quindi dipende dalla size; oppure 1 punto?) | Offset del BE in punti (o euro per lotto) |
| P08e | 3, 9, 10 | Il resto: stop «spostato a mano sul SuperTrend o sugli swing rilevanti», «se sei davanti al computer» | DISCREZIONALE | Gestione manuale; cosa succede se non sei al computer NON NEL PDF | Trailing automatico: SuperTrend (parametri) aggiornato a chiusura M5; swing = frattale N barre |
| P08f | 10 | Pochi punti al TP: «chiude a mano» | DISCREZIONALE | «Pochi punti» non quantificato; intervento manuale | Soglia (punti o % della distanza al TP) per uscita anticipata |
| P09a | 11 | «Size = capitale a rischio / (stop loss x valore di un punto)» | OGGETTIVA | Formula esplicita | nessuno |
| P09b | 11 | Rischio per trade «1-2%», «il rischio consigliato» | PARZIALE | Intervallo, non un valore; e «consigliato» | Valore fisso (1 oppure 2%) |
| P09c | 11 | «3% al giorno - Mai oltre il 3% del conto» | PARZIALE | Non dice se e perdita realizzata o rischio aperto, ne se dopo il limite si smette | Definizione di conteggio e azione al raggiungimento |
| P10a | 12 | «Target a 3R»: «"3 e ambizioso": con uno stop da 143 punti ne dovresti fare 450» | PARZIALE | Sconsiglio, non divieto; tra 1R e 3R nessun limite dichiarato | R massimo ammesso |
| P10b | 12 | «Confondere strategie: quella di Emiliano prende la volatilita d'apertura; l'ORB prende il trend» | DISCREZIONALE | Distinzione concettuale, non una regola di ingresso/uscita | nessuno (non regola) |
| P10c | 12 | Altri «da evitare»: entrare a ridosso di resistenza, candela troppo lontana, stop troppo stretto, box troppo grande | (rimando) | Ripetono P04a/P05/P06c/P07: nessuna regola nuova. Nota: «box troppo grande» e giustificato con l'esempio 1:4/stop 120 (target vs volatilita), non con una soglia di box | vedi righe rimandate |
| P11a | 13 | Indicatore ORB: «50 historical days», «dove c'e scritto 5 mettete 50, poi rivedete i box uno per uno» | DISCREZIONALE (non e regola di trading) | Impostazione visiva dell'indicatore + revisione manuale dei box; non produce una condizione di ingresso/uscita | nessuno per l'EA |
| P11b | 13 | «C'e una strategia, e testata, funziona, si applica la strategia» | DISCREZIONALE (non e regola) | Affermazione/disciplina. Nessun dato di test nel PDF (e un'affermazione, non una prova) | nessuno |
| P12a | 4 | Nasdaq la sera: «e il Nasdaq quello che funziona meglio come ORB» | OGGETTIVA (come scelta strumento/ora) | Strumento e orario sono chiari. L'affermazione «funziona meglio» e senza prova nel PDF | nessuno |
| P12b | 4 | DAX la mattina: «Col DAX l'ORB e normalmente profittevole» | PARZIALE | Orario di apertura DAX NON NEL PDF; «normalmente profittevole» senza dati | Orario DAX (vedi P01c) |

Conteggio e sintesi: vedi 4.3 (9 oggettive, 19 parziali, 14 discrezionali, 2 non nel PDF). Contesto, resistenze, distanza/retest e gestione del residuo non hanno regole oggettive.

## 3. Numeri e soglie citati nel PDF

| Numero | Cosa | Slide | Nota |
|---|---|---|---|
| 15 min | Durata del box | 1, 2, 3, 4 | «Dopo almeno 15 minuti» (slide 2) |
| 15:30-15:45 / 15:44:59 | Box Nasdaq e finestra dell'indicatore | 3, 4 | ora IT |
| 14:30 | Apertura Nasdaq «finche l'America non cambia ora» | 4 | al posto di 15:30 |
| M5 | Timeframe della candela di ingresso | 1, 3 | |
| 9 passi | Struttura del metodo | 3 | |
| 31 punti | Box stretto, «bell'ORB» | 5 | strumento non indicato |
| 100+ punti | Box largo, «piu complesso» | 5 | 100/31 = 3,2, mentre il PDF dice «4 volte la strada» (A6) |
| 1:4, stop 120 | «non lo fai mai» | 5, 12 | target implicito 480 punti |
| 295 punti | Range giornaliero DAX «in quel momento» | 5 | data/fonte non dichiarate |
| 35 / 41 / 53 punti | Esempi di candela lontana (rifiuto da resistenza / imbalance / «si abbandona») | 8 | esempi, non soglie; cosa si misura non dichiarato |
| 30-40 punti (DAX) | Zona del parziale | 3, 9, 10 | «intorno a 40» alla slide 9; Nasdaq non dato |
| 50% | Quota chiusa al parziale | 10 | |
| BE + 1 euro | Stop dopo il parziale | 10 | unita ambigua |
| 1:1 | TP | 1, 3, 10 | |
| 1-2% per trade | Rischio consigliato | 11 | |
| 3% al giorno | Tetto di rischio giornaliero | 11 | |
| 100 EUR, stop 40-50 punti, 9 EUR a punto, 0,22 lotti | Esempio di dimensionamento | 11 | 100/(50 x 9) = 0,222: coerente solo con stop 50 e «9 EUR a punto» per lotto; con stop 40 darebbe 0,28. Conto implicito 5.000-10.000 EUR non scritto |
| 3R, stop 143, 450 punti | Esempio di target «ambizioso» | 12 | 143 x 3 = 429, non 450 (A6) |
| 50 historical days (dove c'e 5) | Impostazione indicatore | 13 | |

## 4. Note

### 4.1 Cosa NON c'e nel PDF (da non inventare)
- Come si calcola il box (high/low con ombre? su M1, M5, tick?).
- Orario di apertura del DAX e durata del box DAX; l'S&P non e mai citato (il PDF parla solo di Nasdaq e DAX).
- Parametri di medie, SuperTrend, VWAP, volumi; definizione di imbalance, cross, retest, rifiuto, "a ridosso", "gocciolino", "piccolino".
- Algoritmo per i livelli H1/H4 e per i "livelli tecnici" (TP, parziale).
- Orario limite per entrare, numero massimo di trade al giorno, riarmo dopo falso breakout, entrata solo sulla prima candela valida, trade in entrambe le direzioni.
- Uscita di fine sessione, filtri notizie/festivi, spread/slippage.
- Punti del parziale per il Nasdaq; soglie sul box, sullo stop minimo, sulla distanza massima.
- Priorita tra TP 1:1 e TP tecnico; cosa fa il residuo del 50% rispetto a un TP 1:1 (il resto «corre» con trailing o ha TP?); cosa fare se non si e davanti al computer.
- Qualsiasi dato di test o statistica: il PDF dichiara «testata, funziona» (slide 13) e «normalmente profittevole» (slide 4) senza numeri.

### 4.2 Ambiguita interne che pesano sulla codifica (segnalate anche per A6)
1. Parziale 30-40 punti + TP 1:1: con un box da 31 punti (esempio «bell'ORB», slide 5) lo stop e circa 31 punti, quindi il TP 1:1 cade a ~31 punti, cioe sotto/dentro la zona del parziale (30-40). Le due regole sono coerenti solo con stop piu larghi (es. 40-50 punti di slide 11).
2. «Stop in pari + 1 euro» e «il resto corre» (slide 3, 10) convivono con «TP 1:1»: non e detto se il residuo abbia un target.
3. P02a (apre e chiude fuori) e P02b (corpo piccolino che ha solo breccato non conta) possono sovrapporsi: serve una soglia sul corpo.
4. «1:4 con stop 120 non lo fai mai... perche superiore alla volatilita media (295)»: il valore sopra 295 e il target (480), non lo stop (120). Il testo non lo precisa.
5. «Contesto» (slide 3 passo 3) e filtro o lettura? Slide 7: solo i volumi sono dichiarati opzionali; per gli altri il PDF non dice se bloccano l'ingresso.
6. Slide 14: «ti da la cornice, ti da i colori, ti dice come fare il disegno» / «il disegno e tuo»: il metodo ammette esplicitamente discrezionalita nell'esecuzione. Questo spiega perche gran parte delle regole di contesto, livelli e gestione non e codificabile senza nostre scelte.

### 4.3 Sintesi della classificazione
- OGGETTIVE (9): P01a (con assunzione sul calcolo del box), P01b, P01d, P01e, P02a (con assunzione "stesso lato"), P06a, P08a, P09a, P12a (come scelta strumento/orario).
- PARZIALI: P01c, P02b, P03a, P03b, P03d, P04b, P04c, P05a, P05b, P06b, P06c, P07a, P07b, P08c, P08d, P09b, P09c, P10a, P12b.
- DISCREZIONALI: P02c, P03c, P03e, P03f, P04a, P04d, P05c, P05d, P08b, P08e, P08f, P10b, P11a, P11b.
- NON NEL PDF: P02d, P03g (e l'elenco al punto 4.1).
- Il nucleo davvero codificabile e piccolo: box 15 min sull'orario, candela M5 con open e close fuori, ingresso a chiusura, stop al bordo opposto, TP 1:1, formula della size. Tutto il resto (contesto, resistenze, distanza/retest, parziale, trailing, TP tecnico) richiede parametri che nel PDF non ci sono.

## 5. Differenze tra la mia lettura e la bozza di C0 (brief.md)

| Bozza C0 | Mia lettura dal PDF |
|---|---|
| P01 «con ora legale USA diversa: la sera si apre alle 14:30» | Il PDF dice: «finche l'America non cambia ora, si apre alle 14:30 invece che alle 15:30», e «per la mattina e uguale». La formula «ora legale USA diversa» e un'interpretazione di C0; il PDF cita solo il caso in cui l'America non ha ancora cambiato ora. Manca nella bozza: «dopo almeno 15 minuti, non prima» (slide 2), e che l'orario del DAX NON c'e nel PDF |
| P02 candela M5 che apre e chiude fuori | Corretto. Mancano: l'osservazione sul colore («se fosse stata verde uno poteva farci una riflessione»), che nessuna soglia di corpo e data, e che la candela valida (prima o qualsiasi) NON e specificata |
| P03 contesto come un'unica regola con VWAP e trend «a favore» | Il PDF distingue: volumi solo per migliorare il contesto (opzionale); VWAP citato SOLO nell'esempio di retest; trend = lettura soggettiva «come ho battezzato il mercato la mattina»; manca nella bozza «nel retest chiusura sopra tutte le medie» e la riga «Da valutare». Non e dichiarato se il contesto sia un filtro obbligatorio |
| P04 resistenze H1/H4: si aspetta la rottura e si entra sulla candela successiva | Corretto, ma «a ridosso» e i livelli sono discrezionali; la riduzione di size non ha misura. Omessa la frase «preferisco perdere l'operazione ma non prendermi il drawdown» (slide 8) |
| P05 «esempi 35/41/53 punti: si aspetta il retest rifiutato e si entra alla chiusura» | Il PDF non mette i tre numeri sullo stesso esito: 35 = con rifiuto da resistenza, 41 = con molta imbalance, 53 = «si abbandona» (non si fa il retest, si lascia perdere). Sono esempi, non soglie, e non dicono cosa si misura. La bozza li fonde in una sola regola di attesa del retest |
| P06 stop non troppo stretto (non sulla candela M5 precedente) | Nel PDF e solo nella lista «da evitare» (slide 12); con lo stop sempre al bordo opposto del box la regola e quasi ridondante, o vale solo per ingressi al retest |
| P07 «1:4 con stop 120 non lo fai mai (oltre la volatilita media; DAX 295)» | Corretto nel testo, ma il PDF non chiarisce se e lo stop o il target (480) a superare la volatilita. Omesso «4 volte la strada» che numericamente non torna con 31 vs 100+ (3,2x) |
| P08 «TP 1:1, TP tecnico sui livelli; parziale 50% prima della resistenza (DAX 30-40)...» | Esatto nelle citazioni. Omesso: «se sei davanti al computer» (slide 3), che non si sa cosa succede altrimenti, e che il PDF non spiega come 1:1 e TP tecnico si combinino. Il parziale ha doppio trigger (resistenza o 30-40 punti) |
| P09 «100 EUR, stop 40-50 punti, 0,22 lotti» | Il PDF aggiunge «9 EUR a punto»; 0,22 lotti torna solo con stop 50 (100/(50x9)). Il conto non e dichiarato. Per il perimetro: nessuna taglia nel nostro lavoro |
| P10 «da evitare ... target a 3R» | Il PDF dice «"3 e ambizioso"», non un divieto assoluto; «box troppo grande» e motivato con l'esempio 1:4/stop 120 e non con una soglia sul box. Con 143 punti x 3 = 429, non 450 |
| P11 «e testata, funziona, si applica» | Trascritto, ma classifico come affermazione/disciplina senza alcun dato nel PDF, e non come regola di trading; le 50 historical days sono un'impostazione visiva |
| P12 Nasdaq la sera / DAX la mattina | Corretto. Aggiungo che il PDF non nomina l'S&P |
| Bozza non cita | Slide 2 (idea: liquidita alle 15:30, stabilizzazione, direzione), slide 14 (la cornice e il disegno sono del trader), «Da valutare» (slide 7) |

La bozza di C0 e quindi nel complesso fedele nelle citazioni, ma tende a presentare come regole nette elementi che nel PDF sono esempi (35/41/53), letture soggettive (trend, contesto, TP tecnico) o dettagli non specificati; il numero P01-P12 non coincide con i 9 passi del PDF (slide 3).
