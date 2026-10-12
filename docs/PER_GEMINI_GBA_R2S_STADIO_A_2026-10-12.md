# PER GEMINI -- Breakout di canale su oro, sonda dei costi sui simboli gemelli (argento, Nasdaq, DAX, Dow): regole di lettura scritte PRIMA dei numeri, tre domande -- 12/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (non e' allegato a questo file: lo passa esplicitamente l'invio, insieme alla memoria condivisa e alla BASE) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo e contiene solo cio' che serve alle tre domande della sez. 5.
**Perche' esiste**: regola di casa dell'11/10, punto 3 (un piano di misura nuovo genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata, PRIMA che la misura giri e si apra qualunque risultato). **Nessuna delle passate descritte qui e' stata ancora eseguita**: al 12/10 non esiste nessuna passata di questo motore su un simbolo diverso dall'oro. Quello che ti chiediamo e' dove le regole di lettura che abbiamo scritto prima dei numeri possono sbagliare, non di interpretare numeri che non esistono.
Niente preset, righe o script di lancio, numeri di conto, numeri magic, chiavi, nomi di macchine o terminali, o nomi di terzi in questo documento. Gli importi, dove compaiono, sono quelli del tester (deposito fittizio), non di un conto.
Etichette nostre: **[MISURATO]** rifatto da noi su file del repo; **[DERIVATO]** conto su numeri misurati; **[INFERITO]** ragionamento o stima nostra, non verificata; **[NON MISURATO]** il numero non esiste.

**Cosa chiediamo, e come rispondere (ruoli del protocollo)**: **Q1, Q2 e Q3 tutte al ruolo B** (avvocato del diavolo: costruisci il contro-esempio, non confermare). Una domanda per chiamata. Tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero inventato. Un contro-esempio vale solo se porta i NUMERI: quale cella, quale valore, quale etichetta uscirebbe e quale sarebbe quella giusta.

---

## 1. Il motore e la domanda dello stadio A
- **Motore** [descrizione nostra]: breakout di un canale di 48 barre a favore di una media mobile esponenziale a 100 periodi; ingresso a mercato alla chiusura oltre il canale, long e short; ATR a 14 periodi; **filtro di spread**: l'ingresso e' scartato se lo spread (ask meno bid, letto sul primo tick della barra nuova) supera 0,05 x ATR; stop e trailing a 2,5 x ATR, breakeven armato a 1,0 x ATR, uscita a tempo dopo 48 barre; **una posizione per volta** (un segnale mentre c'e' una posizione aperta e' scartato); lotto fisso 1,00. Il timeframe del segnale e' l'unica variabile che cambia fra le celle; EMA e ATR seguono il timeframe del segnale.
- **Cosa misura lo stadio A** [piano di misura]: quali coppie (simbolo, timeframe) hanno abbastanza ingressi, e a che costo, per meritare lo **stadio B** (tick reali, tre tranche). Una tranche sola (luglio-settembre 2026, tre mesi, un solo regime), **Modello 1** del tester (barre da 1 minuto con spread per barra: veloce, e' una SONDA di conteggio e di costo, nessun profit factor si legge come merito). Celle: argento (XAGUSD) M1 e M15; Nasdaq (NASUSD), DAX (D30EUR) e Dow (U30USD) M5 e M15. Piu' una passata **ancora** sull'oro che deve rifare la sonda precedente al centesimo (158 ingressi). In tutto 9 passate, circa 12 minuti.
- **Perche' il costo conta**: la frontiera di casa e' `stop >= 40 x costo` (costo = spread piu' commissione); sotto 13,3x un motore e' escluso per costo, fra 13,3x e 40x e' "FRA" (si misura per capire, non puo' diventare sedia), da 40x passa. Sugli indici la commissione e' zero [MISURATO su 302 operazioni vere del nostro broker]; sull'argento e' [NON MISURATO].

## 2. Il fatto che cambia come si legge il costo
Con il filtro a 0,05 x ATR, ogni ingresso ha spread <= 0,05 x ATR, quindi `stop/spread = 2,5 x ATR / spread >= 50x` **per costruzione**. [DERIVATO; l'EA stampa "stop/spread minimo garantito = 50,0x"]. Sull'oro gli ingressi hanno mediana 55,9x (Modello 1) e 58,8x (tick reali, letta dal nostro lettore). Conseguenza: il costo letto **sugli ingressi** non puo' mai smentire una nostra attesa su nessun simbolo: e' sopra 50x per costruzione. Il costo vero di un (simbolo, timeframe) sta nei **segnali scartati**: l'EA scrive in OGNI riga di segnale (anche scartato) il campo `stop/spread` a piena precisione di calcolo (stampato a 1 decimale), l'ora server, il lato, ATR e spread (questi due a 2 decimali). Da qui il **costo grezzo misurato (C3G)**: mediana del campo `stop/spread` di tutte le righe di segnale del giornale della passata, per cella, per fascia oraria e per lato. Le righe a spread zero (`-1,0x`) valgono **infinito** e si contano a parte (escluderle abbasserebbe la mediana proprio verso l'esclusione).

## 3. I numeri della sonda precedente sull'oro (T1 = luglio-settembre 2026)
Fonti: giornali dell'EA delle passate «S0» (Modello 1) e «R1A» (tick reali), stessa tranche, stesse 6.973 righe di segnale (le barre sono le stesse). [MISURATO, ricontato da noi oggi sul giornale: 6.973 righe, nessuna a spread zero]

| | Modello 1 (S0) | Tick reali (R1A) |
|---|---:|---:|
| righe di segnale | 6.973 | 6.973 |
| ingressi (= ingressi tentati) | 158 | 128 |
| righe scartate (SALTATO: spread piu' posizione aperta) | 6.815 (6.520 + 295) | 6.845 |
| **C3G della cella (mediana di `stop/spread`)** | **22,80x** | **21,60x** |
| C3G lato BUY / lato SELL | 23,25x / 22,30x | 22,10x / 21,00x |
| `stop/spread` degli ingressi (dal giornale) | 55,85x | 56,95x |
| ATR mediana / spread mediano delle righe | 1,84 / 0,21 | 1,84 / 0,22 |

(Per Modello 1: 6.973 = 158 + 6.520 per spread + 295 per posizione aperta; per i tick reali la scomposizione fra spread e posizione aperta non e' stata ricontata oggi.) Il nostro lettore dava invece 55,9x (Modello 1) e 58,8x (tick reali) sugli ingressi: e' una misura diversa (non sullo stesso campo del giornale) e la differenza con la colonna del giornale non e' stata spiegata [NON MISURATO]. Un calcolo esterno (barre M1 storiche di un altro fornitore piu' lo spread vivo del nostro broker, senza tester) aveva stimato 21,6x per lo stesso campione e il tester a Modello 1 con filtro largo (0,35) aveva dato 22,1x [fonte: piano di misura del 10/10].

**Per fascia oraria (ora server) e per lato, Modello 1** [MISURATO]:
| fascia | righe | C3G fascia | BUY (n) | SELL (n) | C3G tick reali, fascia |
|---|---:|---:|---|---|---:|
| asia 0-7 | 2.314 | 19,80x | 21,40x (1.139) | 18,50x (1.175) | 19,30x |
| europa 7-12 | 1.426 | 24,50x | 24,70x (694) | 24,50x (732) | 22,10x |
| pausa 12-14 | 778 | 26,20x | 26,05x (438) | 26,35x (340) | 25,10x |
| USA apertura 14-17 | 833 | 39,20x | 37,35x (442) | 40,00x (391) | 37,60x |
| USA pomeriggio 17-22 | 1.346 | 20,60x | 21,30x (561) | 19,90x (785) | 19,30x |
| rollover 22-24 | 276 | 10,65x | 10,60x (188) | 11,20x (88) | 10,60x |

Letture [DERIVATO]: (a) la cella a 22,80x e' FRA (13,3-40x) ma una fascia (rollover) sta a 10,65x e una (USA apertura) a 39,20x, con i due lati a 37,35x e 40,00x: il costo non e' uno solo. (b) Dentro la stessa fascia i due lati si separano fino del 16% (asia: 21,40x contro 18,50x). (c) Modello 1 contro tick reali: C3G della cella +5,6%, per fascia da +0,5% (rollover) a +10,9% (europa); gli ingressi sono 158 contro 128 (+23%, rapporto tick/Modello 1 = 0,81); lo spread mediano di europa e' 0,17 a Modello 1 contro 0,20 a tick reali, ATR identico (le barre sono le stesse). (d) Una stima precedente del costo grezzo come "mediana ponderata delle mediane di fascia" faceva 19,48x contro 22,80x: sbagliava del -14,6% verso l'esclusione ed e' stata scartata come criterio.

## 4. Le regole di lettura gia' scritte (prima dei numeri) e le attese

**Soglie congelate** (copiate dal file madre, non spostate): costo `>= 40x` PASSA; 13,3-40x FRA; `< 13,3x` ESCLUSO PER COSTO. Per questo lotto: **S = 13,3x per gli indici; S = 6,65x per l'argento** (meta': margine prudenziale scritto prima dei numeri per l'arrotondamento a 2 decimali di ATR e spread nel giornale, che sull'argento, dove lo spread vale 0,04, sposta una mediana fino al 25%).

**Esiti per ogni (simbolo, timeframe), tre e nient'altro**, validi solo se la passata e' completa e i controlli di coerenza sono verdi (CE: simbolo vero, costo >= 50x sugli ingressi, segnali EA = ingressi tentati + scartati per spread + posizione aperta, `ingressi tentati - n <= 1`, lotto):
- **(A) PASSA ALLO STADIO B**: n (ingressi della tranche) **meno gli ingressi a spread zero** >= 30, E costo sugli ingressi >= 40x (vero per costruzione col filtro). Si scrive accanto il C3G, e se e' < 40x la frase «FRA sui segnali grezzi, PASSA solo grazie al filtro» (o «SOTTO 13,3x ...»). E' un fatto da portare allo stadio B, non una promozione.
- **(B) NON PASSA PER n**: n < 30. Si scrivono n, la quota scartata per spread e il C3G (cella e tutte le fasce). **«ESCLUSA PER COSTO col numero»** (la casella «simboli gemelli» del nostro certificato si chiude per quella cella) **solo se valgono TUTTE E QUATTRO**: (i) **almeno una** fascia con >= 100 righe di segnale; (ii) C3G < S in **ogni** fascia con >= 100 righe; (iii) C3G della **cella** < S; (iv) C3G < S **su ciascun lato** (BUY e SELL), ciascun lato con >= 100 righe. Altrimenti l'esito e' «n insufficiente a Modello 1 su una tranche» (non «escluso»).
- **(C) NON SI LEGGE**: passata fallita o controlli di coerenza rossi.
- **Eccezione n = 0**: un conteggio a zero operazioni e' ammesso (non e' un guasto) solo se «ingressi tentati» = 0 E «scartati per spread» >= 1 (con segnali = 0 la frase «tutti scartati» sarebbe vera a vuoto).
- **Lo strumento che legge il C3G ancora non esiste**: va scritto e passato dal nostro cancello prima di aprire i risultati; senza di lui nessuna cella puo' uscire «ESCLUSA» (esce «n insufficiente»).
Questa forma e' il risultato di **cinque correzioni** del nostro cancello su stesure precedenti (quantificatore universale vero a vuoto; una fascia sola a decidere per la cella; i due lati mescolati; mediana di mediane che sbaglia verso l'esclusione; righe a spread zero tolte dalla mediana). **Non ricopiarle come contro-esempi tuoi: sono gia' dentro la regola.**

**Attese scritte prima dei numeri [INFERITO: stime su stime, scalate dal comportamento dell'oro; bande larghe di proposito]**
| (simbolo, timeframe) | C3G della cella atteso | quota dei segnali liberi scartata per spread | n ingressi attesi | esito atteso |
|---|---|---|---|---|
| argento M1 | < 13,3x (stima 2,2x) | >= 97% | 0-30 (centro ~5; 0 probabile) | (B) |
| argento M15 | < 13,3x (stima 9,6x) | >= 95% | 0-15 | (B) |
| Nasdaq M5 | 35-50x (stima 42,7x) | 55-85% | 80-450 | (A) |
| Nasdaq M15 | >= 40x (76,9x) | 10-50% | 40-250 | (A) |
| DAX M5 | < 40x, FRA (29,7x) | 70-95% | 40-300 | (A) con «FRA sui grezzi» |
| DAX M15 | >= 40x (53,5x) | 30-70% | 30-200 | (A) |
| Dow M5 | < 40x, FRA (25,3x) | 80-97% | 25-200 | (A) con «FRA sui grezzi»; (B) possibile |
| Dow M15 | >= 40x (45,5x) | 40-80% | 25-180 | (A) sul bordo |
Fuori banda = si legge prima il giornale, non e' un risultato. Smentita dell'argento: n >= 30 in una cella, oppure quota scartata < 90%, oppure C3G >= 13,3x nella cella o in una fascia con >= 100 righe.
Spread di partenza [MISURATO / fonte]: argento 0,041 USD da **una sola lettura** (nessun logger vivo), ADR 1,095 USD su n = 4 («non citabile»); Nasdaq 1,8 punti, DAX 1,7 punti all'apertura cash e 2,7-2,8 fuori cassa, Dow 2,0 o 3,0 punti a seconda della fonte (+50% fra due fonti nostre non riconciliate). L'ATR delle attese e' [INFERITO] come ADR x radice(minuti del timeframe / minuti del giorno di negoziazione).

**Limiti dichiarati della misura**: un solo regime; Modello 1 e' una sonda (la distorsione sull'oro e' quella della sez. 3); lotto fisso 1,00 (non confrontabile in valuta fra simboli); l'argento non ha logger, la sua storia a 1 minuto sul nostro tester e' [NON MISURATO] (se manca, la passata esce con un motivo); il lettore dei risultati ha costanti dell'oro cablate (commissione di 0,04 USD per oncia, sei fasce orarie dell'oro), per cui sugli altri simboli si legge solo la riga «solo spread» e le fasce sono descrizione.

---

## 5. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q1 (ruolo B) -- Dove la regola di lettura sbaglia?**
Dato che la motiva: sez. 3 e 4. La regola decide due cose irreversibili: «ESCLUSA PER COSTO» (chiude per quella cella la casella dei simboli gemelli) e «PASSA» (spende le passate dello stadio B). Con il costo vero nel C3G e non negli ingressi.
Domanda: costruisci un caso **concreto, con numeri**, in cui la regola della sez. 4 fa uscire **«ESCLUSA PER COSTO»** per una cella il cui costo vero **non** e' sotto soglia S, oppure fa uscire **«PASSA»** (esito A) per una cella il cui costo vero **e'** sotto soglia. Indica la cella, i valori di C3G per cella, fascia e lato, l'n, e quale etichetta sarebbe stata quella giusta e perche'. Non ricopiare i cinque difetti gia' corretti (sez. 4). Se non ne trovi uno che regga, scrivi NON LO SO e dimmi quale parte della regola non hai potuto attaccare.
Nostra attesa [INFERITO]: la regola sbaglia semmai verso «n insufficiente» (mai verso «ESCLUSA» a torto), perche' ogni condizione e' congiunta e a campione corto non si pronuncia. I punti che temiamo: (1) la soglia di 100 righe per fascia/lato lascia fuori fasce piu' piccole dove sta la sessione cash di un indice (che un'EA con filtro orario potrebbe usare); (2) il costo e' letto sul primo tick della barra del segnale, non sul prezzo di fill; (3) la porta «PASSA» sugli ingressi e' vera per costruzione, quindi una cella con C3G in zona FRA (13,3-40x) passa allo stadio B «solo grazie al filtro», mentre la regola del piano dice che una cella FRA «non puo' diventare sedia»: non sappiamo se il filtro seleziona barre di spread basso che sono anche barre diverse (quiete) da quelle che contano. Contro-esempio nostro: sull'oro, fascia rollover 10,65x con 276 righe (sotto 13,3x) mentre la cella e' 22,80x: la regola dice correttamente che l'oro non e' escluso; se invece il motore fosse limitato al solo rollover il C3G di quella sola fascia lo escluderebbe, e la regola non lo vede perche' guarda la cella.

**Q2 (ruolo B) -- Il Modello 1 distorce il costo dei CFD indice e dell'argento in modo diverso dall'oro?**
Dato che la motiva: sez. 3, ultima colonna e lettura (c). Sull'oro Modello 1 contro tick reali sposta il C3G della cella di +5,6% (da +0,5% a +10,9% per fascia), gli ingressi di +23%, lo spread mediano di una fascia da 0,20 a 0,17; l'ATR no (stesse barre). Il giornale legge lo spread sul primo tick della barra; a Modello 1 il tester usa lo spread registrato nella barra da 1 minuto.
Domanda: per i CFD indice (Nasdaq, DAX, Dow: spread di 1,7-3,0 punti, sessione cash e orari fuori cassa) e per l'argento (spread 0,041 su un ATR di 0,02-0,30 USD, 3 decimali), costruisci il meccanismo per cui la distorsione di Modello 1 su spread/ATR sarebbe **diversa per segno o per ordine di grandezza** da quella dell'oro, e indica la **misura minima** (la piu' economica nei nostri mezzi: una passata a tick reali sugli indici dura 1-2 minuti per trimestre [INFERITO da un caso passato, non misurato su questi simboli]) che lo mostrerebbe, con il valore che la confermerebbe e quello che la smentirebbe.
Nostra attesa [INFERITO]: la distorsione e' sul solo spread (l'ATR e' calcolato sulle stesse barre), con segno «Modello 1 spread <= tick»: C3G e n sopravvalutati, cioe' un «PASSA» puo' essere di troppo (costa minuti) e un «ESCLUSA» a torto e' piu' difficile. Contro-esempio nostro: barre indice fuori dalla sessione cash con spread registrato a zero o fisso in storia producono righe `-1,0x` (spread zero, costo apparente nullo): il segno si invertirebbe. Le contiamo (sono gia' nella regola dell'n), ma non sappiamo quante siano.

**Q3 (ruolo B) -- C'e' un'altra spiegazione per cui l'argento fa zero operazioni?**
Dato che la motiva: sez. 4, riga argento. La nostra attesa e' che l'argento faccia 0-30 ingressi (centro 5, zero probabile) per **costo**: con spread 0,041 servirebbe ATR >= 20 x 0,041 = 0,82 USD (filtro a 0,05 x ATR), mentre l'ATR a M1 e' stimato 0,02-0,08 e a M15 0,08-0,30 [INFERITO].
Domanda: oltre al costo, quale altra causa porta il motore a zero ingressi (e a zero operazioni nel report) sull'argento, **senza che lo strumento di controllo lo veda come costo**? Per ogni causa: come si distingue dal costo leggendo solo il giornale dell'EA e il report del tester (campi, conteggi, valori), e quale valore la fa escludere. Le cause che abbiamo gia' coperto, da non ripetere: ordine rifiutato dal broker (ingressi tentati > 0 con operazioni = 0 diventa «non si legge»); storia a 1 minuto mancante (segnali EA = 0, «non si legge»); lotto 1,00 ridotto (l'EA lo dichiara); simbolo di un altro report (il driver mette KO); ATR non valido (contatore dedicato).
Nostra attesa [INFERITO]: le cause residue stanno nella lettura di spread e ATR a 2 decimali sull'argento (una mediana che sembra 5x e vale 24x: errore massimo che abbiamo trovato esaurendo le combinazioni di arrotondamento) e nel valore di spread di partenza (una sola lettura: se lo spread vero fosse 0,010-0,020 nelle ore liquide il costo grezzo cambierebbe di un fattore 2-4). Smentita nostra dell'ipotesi «costo»: spread della cella > 0,08 o < 0,02 USD alle barre di rottura, oppure quota scartata < 90%.

---

## 6. Fonti nel repo (branch `lavoro`, commit di oggi)
Piano di misura del motore (sezioni sulla casella dei simboli gemelli e sul timeframe), scheda dello stadio A e i cinque file prova del lotto (attese, smentite, soglie e blocchi di lettura L3/C3G/CE/esiti), lettura della sonda precedente sull'oro, giornali dell'EA delle passate «S0» e «R1A» archiviati (ricontati oggi da noi con un conteggio indipendente dal lettore). Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuti insieme a questo file).
