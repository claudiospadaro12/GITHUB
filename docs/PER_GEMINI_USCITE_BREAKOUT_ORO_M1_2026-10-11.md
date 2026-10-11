# PER GEMINI -- Breakout di canale su oro M1: la gestione dell'uscita messa ad asse (9 celle, tick reali) -- 11/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo.
**Perche' esiste**: regola di casa dell'11/10 (un ZIP di misura letto genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata). Niente numeri, impostazioni, conti o importi di terzi in questo documento: solo misure nostre.
Etichette nostre: **[MISURATO]** rifatto da noi su file del repo; **[DERIVATO]** conto su numeri misurati; **[INFERITO]** ragionamento nostro; **[POST-HOC]** letto sugli stessi dati su cui nasce l'ipotesi (ipotesi, mai prova); **[NON MISURATO]** il numero non esiste.
Fonti: file del repo (branch `lavoro`) con sezione, **al commit di oggi**. Alias: **lettura R2U** = lettura del 11/10 della corsa «uscita ad asse», sezioni «Cancelli», «I numeri», «Lettura contro le soglie scritte prima», «Che cosa significa»; **piano R2** = piano delle misure del 10/10, sez. 1.5 (motore prima dei costi) e sez. 4.1 (frontiera del costo); **lettura R1A** = lettura del 10/10 della replica di partenza. Le soglie delle celle erano scritte nel file prova di ogni lotto PRIMA dei numeri.
**Nota importante**: l'EA di cui parliamo, «il nostro EA di breakout di canale su oro M1», e' una **ricostruzione nostra** (da una descrizione a voce e da foto di un pannello di terzi): i numeri dicono cosa fa *quella ricostruzione* sul feed del nostro broker, non cosa fa l'EA di altri.

**Come rispondere (ruoli del protocollo)**: tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (file e sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ruolo **A** (cacciatore): Q1. Ruolo **B** (avvocato del diavolo): Q2. Ruolo **C** (auditor): Q3. Una domanda per chiamata. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero, un autore o un titolo inventato.

---

## 1. Il motore, per struttura  [la descrizione e' un'ipotesi di ricostruzione; il resto e' MISURATO]
- **Ingresso**: breakout di un canale di N barre M1, a favore di una EMA. Quando la **chiusura** supera il massimo (o scende sotto il minimo) delle N barre precedenti, entra a mercato nella direzione della rottura (long e short). Filtro di spread espresso come frazione dell'ATR: la replica usa la frazione piu' stretta, quindi passa solo il 5,2% dei segnali (filtro di fatto di volatilita') [lettura R1A; piano R2 sez. 1.8].
- **Uscita**: stop iniziale e trailing a multipli di ATR (il trailing segue l'estremo raggiunto dall'ingresso); **breakeven** armato a un multiplo di ATR; **uscita a tempo** dopo un numero fisso di barre. Nessun take profit. Una posizione per volta.
- **Le leve d'uscita che mettiamo ad asse, in parole**: il breakeven (spento / piu' vicino / piu' lontano), quale ATR guida il trailing (fisso sul segnale o aggiornato), la distanza del trailing (piu' stretta / piu' larga / spenta), l'uscita a tempo (spenta).
- **Condizioni di misura** [MISURATO]: oro, M1, **tick reali** (modello 4), costi veri del feed del broker (spread del tick + commissione), lotto fisso, tester a latenza zero (il bias piu' favorevole a uno scalper). **Un solo regime: gennaio-settembre 2026**, in tre tranche fisse: T1 luglio-settembre / T2 aprile-giugno / T3 gennaio-marzo.

## 2. I nove numeri  [MISURATO; lettura R2U, sez. «I numeri»]
PF netto di costi (PF_V) sulla somma delle 3 tranche; PF per tranche dal report del tester.
| cella | cosa cambia | n | PF_V | PF T1 / T2 / T3 |
|---|---|---:|---:|---|
| REPL | valori di partenza | 933 | 0,855 | 0,83 / 0,77 / 0,89 |
| BEOFF | breakeven mai armato | 882 | 0,843 | 0,78 / 0,74 / 0,89 |
| BE05 | breakeven molto vicino | 1.074 | 0,778 | 0,63 / 0,71 / 0,82 |
| BE15 | breakeven piu' lontano | 898 | 0,846 | 0,81 / 0,74 / 0,89 |
| ATRFIX | ATR del trailing fisso al segnale | 926 | 0,886 | 0,72 / 0,81 / 0,94 |
| TOFF | uscita a tempo spenta (controllo positivo) | 932 | 0,849 | 0,83 / 0,77 / 0,88 |
| K15 | trailing piu' stretto | 1.131 | 0,848 | 0,89 / 0,91 / 0,83 |
| K35 | trailing piu' largo | 873 | 0,911 | 0,96 / 0,82 / 0,94 |
| KOFF | trailing spento | 859 | 0,900 | 0,98 / 0,67 / 0,97 |

- **Rumore** [MISURATO, bootstrap per giorno, 5.000 ricampionamenti; piano R2 sez. 1.6; lettura R2U sez. «Lettura contro le soglie»]: la REPL fa PF_V 0,855 con intervallo 2,5-97,5% = **0,70-1,03**. **Nessuna delle 9 celle supera 1,03** (massimo K35 0,911): tutte indistinguibili dalla REPL e da 1,0 (soglia S8, scritta prima).
- **27 tranche su 27 hanno PF < 1** (massimo 0,98, KOFF T1); K35 e KOFF non hanno nessuna tranche >= 1. Contro-esempio cercato da noi («il lettore nasconde una cella buona nella somma»): smentito sul numero del tester stesso. Per lato: massimo K35 long 1,03 (n 415) e KOFF long 1,01 (n 408), dentro il rumore.
- **Controllo positivo** [MISURATO]: spegnere l'uscita a tempo cambia **1 operazione su 933** (932) e il PF di 0,006. Non e' una leva su questa macchina: la durata mediana e' 7,4 minuti, p90 19,2 (lettura R2U; piano R2 sez. 1.3). Che il tester risponda alle altre leve si vede in n: 1.074 (BE05) e 1.131 (K15) contro 859 (KOFF) e 933 (REPL). Gemella di controllo: la prima tranche rigirata con altro identificativo ridà **identica** la corsa di partenza (128 operazioni, 256 deal confrontati): la macchina e' la stessa.
- **Direzione, senza giudicarla** [POST-HOC]: il breakeven stretto peggiora (0,778 contro 0,843 a breakeven spento); trailing largo o spento migliora di circa +0,05, ma K15 (0,848) e REPL (0,855) non sono monotoni con K35/KOFF. Tutte le celle sono FRAGILI (togliendo le 5 migliori operazioni il netto peggiora).

## 3. Il motore prima dei costi e la frontiera del costo  [DERIVATO]
- **Lordo di costi** [piano R2 sez. 1.5]: circa **-0,014 R per operazione con errore standard 0,028 R**: indistinguibile da zero (costi circa 0,031 R per operazione: commissione + spread d'ingresso + slittamento sugli stop). Per questo il PF_V non puo' salire sopra 1 con una leva d'uscita: non c'e' un vantaggio da catturare meglio. Sotto l'ipotesi che il prezzo sia una martingala, qualsiasi regola d'uscita lascia l'aspettativa uguale a -(spread + commissione) [INFERITO]: l'uscita cambia la FORMA (win rate, payoff, drawdown), non il merito.
- **Frontiera del costo** [DERIVATO; lettura R2U, invariata]: stop / (spread + commissione) con **mediana 49 volte**, 0% sotto il pavimento duro di 13,3 volte; la frontiera di casa e' 40 volte. Per timeframe, su proxy a barre (NON il feed del broker): M1 mediana 21,6 volte, M3 40,1 (bordo), M5 53,3, M15 95,9 [piano R2 sez. 4.1].

## 4. Verdetto di casa  [nostro]
**«Nulla per il regime di scoperta»** (gen-set 2026, M1): nessuna cella va in tranche di conferma. **NON «morto»**. Del certificato a 5 caselle: PF e n misurati (1, 2); la casella 3 (uscita ad asse) e' chiusa **solo per le leve senza codice** (breakeven, ATR del trailing, distanza del trailing, tempo); mancano la **4** (simboli gemelli) e la **5** (altri timeframe), le **uscite che richiedono codice** (filtro anti-falsa-rottura; uscita a mercato se la candela d'ingresso chiude contro) e la prova di regime fuori dal 2026. In coda, non girati: un lotto notturno (ore 0-6 server, M1 e M5) e uno su 2024-25 (merito non misurabile oggi per n).
**Regole di casa per le tue risposte**: niente griglie su un motore sotto 1 (regola del 19/08): si allarga su meccanismi, simboli, timeframe, uscita; stop >= 40 x (spread + commissione); cella = centro dell'altopiano, mai il picco; criterio per regimi firmato: PF_V > 1,0 in **ogni** regime con almeno 150 operazioni, long e short letti separatamente. Taglie, rischio, conti e spese = «Firma Claudio: SI». Nessun conto di campo e' toccato da questo lavoro.

---

## 5. Le domande (massimo 3, una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q1 (ruolo A) -- Una misura NUOVA che possa falsificare «l'ingresso non ha edge su M1 in nessuna ora»**
Dato che la motiva: sez. 3 (lordo di costi indistinguibile da zero su 933 operazioni) e sez. 2 (nove uscite diverse, stesso risultato dentro il rumore).
Domanda: dato un lordo di costi circa zero su queste operazioni, quale misura NUOVA (un meccanismo, un simbolo o un timeframe: **mai una griglia sullo stesso motore**) puo' **falsificare** l'ipotesi «l'ingresso non ha edge su M1 in nessuna ora»? Per ognuna (massimo 2): cosa tocca (nome esatto o «nome da verificare»), **attesa scritta con banda E numero dell'ipotesi alternativa**, **contro-esempio** (la situazione in cui darebbe «positivo» per una ragione diversa), costo in passate (circa 48 secondi a passata a tick reali), «Firma Claudio SI/NO». Non proporre i punti gia' in sez. 4 (simboli gemelli, altri TF, lotto notturno, uscite a codice): se coincidi, dillo.
Nostra attesa [INFERITO]: il motore e' a zero e la misura che serve e' un altro meccanismo o un altro mercato, non un'altra uscita. Contro-esempio nostro: un simbolo piu' costoso o un TF dove la frontiera del costo non regge darebbe «positivo» o «negativo» per il solo costo, non per l'ingresso.

**Q2 (ruolo B) -- La leggera superiorita' di trailing largo o spento e' reale?**
Dato che la motiva: sez. 2, ultima voce: K35 e KOFF stanno circa +0,05 sopra la replica, ma K15 non e' monotono e tutte le celle sono dentro l'intervallo di rumore.
Domanda: c'e' un modo **corretto** di dire se la leggera superiorita' di trailing largo o spento (circa +0,05) e' reale, **senza fare altre griglie**? Indica la procedura (per esempio un confronto appaiato per giorno sulle stesse operazioni, una permutazione, una soglia), **quale numero produrrebbe l'ipotesi «e' rumore»** e se cade nella banda, e dove la procedura stessa potrebbe sbagliare (stessi giorni nelle nove celle: non sono nove prove indipendenti).
Nostra attesa: non distinguibile dal rumore; una procedura appaiata dara' un intervallo che include zero. Contro-esempio nostro: se il vantaggio fosse solo meno operazioni (859 contro 933), meno costi, non migliore uscita.

**Q3 (ruolo C, solo se ne resta una) -- Quale errore di lettura ci vedi tu che noi non vediamo?**
Dato che la motiva: la lettura R2U e' nostra e le abbiamo cercato contro-esempi solo noi.
Domanda: rifai dai dati scritti qui i conti che puoi (per esempio che «27 su 27 sotto 1» sia compatibile con un PF vero di 1,0 e con tranche non indipendenti; che 1 operazione su 933 sia davvero un controllo positivo valido) e dici **quale errore di lettura o di confronto** (unita' deal/posizioni, periodo, tranche sovrapposte, soglia scelta dopo i numeri) vedi tu e noi no. Rispondi NON LO SO dove manca un dato.
Nostra attesa: nessun errore che ribalti il verdetto «nulla per il regime di scoperta». Contro-esempio nostro: se la sola uscita a tempo non e' una leva, il controllo positivo prova solo che il tester risponde a *qualche* leva (si vede in n), non a quella.

---

## 6. Limiti (cosa NON e' nei numeri)
1. **Un solo regime** (gen-set 2026), **3 tranche**, tutte gia' usate per far nascere le ipotesi della sez. 3: il merito fuori da questo regime e' **NON MISURATO**.
2. **Casella 4 (simboli gemelli) e casella 5 (altri timeframe) NON misurate**; **nessuna uscita che richieda codice provata**. «Nulla per il regime di scoperta» non e' «l'ingresso non ha edge ovunque».
3. La ricostruzione non e' l'EA originale: mancano timeframe di EMA e ATR, ore, versione.
4. Il giornale dell'EA segnala errori di spostamento dello stop (trailing o breakeven non applicato) da 20 a 156 per lotto e di chiusura a tempo fino a 187: il PF del report coincide col PF_V in ogni tranche, ma e' un punto da guardare [lettura R2U, sez. «Cancelli»].
5. Il lordo di costi (-0,014 R) e' un ordine di grandezza con forbice 0,01-0,03 R; il motivo d'uscita e' dedotto dal livello dello stop.
6. Il tester ha latenza zero: la sensibilita' al ritardo e' NON MISURATA.
7. Intervalli di rumore per giorno: i giorni non sono del tutto indipendenti (stesso regime).

## 7. Fonti nel repo (branch `lavoro`, commit di oggi)
Lettura R2U 11/10 (sez. «Cancelli», «I numeri», «Lettura contro le soglie scritte prima», «Che cosa significa») -- piano R2 10/10 (sez. 1.3, 1.5, 1.6, 1.8, 4.1) -- lettura R1A 10/10 -- file prova dei lotti, con soglie e attese scritte prima dei numeri. Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuti insieme a questo file).
