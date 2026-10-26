# A6 - Critica dei RISULTATI di S1 (SALA-BIAS-001, secondo incarico)

Revisore: A6 (indipendente). Oggetto: codice e risultati di A4 (`agents/A4/`), regole R1-R10, verdetto "C, NON CONCLUSIVO (potenza)". Non ho letto `agents/A7/verifica_studio`. Non ho modificato nessun file del progetto: ho lavorato su una copia in `scratchpad/a6_copy` (mutanti in `scratchpad/a6_mut`, mie verifiche in `scratchpad/a6_work`: `indep.py`, `sub.py`, `sub2.py`, `sub3.py`, `sub4.py`, `sub5.py`, `prefix_all.py`).

## 0. Sintesi (10 righe)
1. **I comandi di A4 funzionano e sono riproducibili.** `python3 -I bias_replica.py --autotest`: 33/33 PASS in 8 s. `python3 -I studio_S1.py`: 16 s, output **identico byte per byte** a `studio_S1_output.txt` consegnato (tolta la riga di data). Gli SHA256 di `SHA256_CONGELAMENTO.txt` coincidono con i file attuali (sei file su sei).
2. **Nessun look-ahead trovato nel codice.** Ho letto riga per riga swing, BOS/CHoCH, EMA, ATR, RSI, MACD, volume, price action, regola W1, fusione domeniche, rendimenti. Test del prefisso mio su 980 date (lunedi, venerdi, giorni dopo un buco >= 4 giorni, confini d'anno) contro il file di PRODUZIONE `score_A4.csv`: differenza massima 5e-11.
3. **Un buco nei test, non nel codice (Media):** i test di causalita (T9, T12, T13) percorrono il ramo `only=lista` di `calcola_overall`, mentre lo studio usa il ramo `only=None` (ciclo `while`). Un mutante con look-ahead di una settimana intera SOLO nel ramo di produzione passa TUTTI i 33 test. Il codice attuale e giusto (equivalenza dei due rami verificata, differenza 0 su 824 date), ma il test non lo garantirebbe.
4. **Il verdetto C e giustificato, ma per una ragione diversa da quella scritta.** La regola R7 ("potenza sufficiente se MDE <= |deriva a 20 giorni|") rende **B irraggiungibile per costruzione**: servirebbero circa 657 osservazioni non sovrapposte per stato contro 107/56 disponibili. C e quindi predeterminato da R7, non dai dati (Alta). Il C resta corretto perche nessun criterio e soddisfatto (A escluso) e l'IC dello spread e troppo largo per escludere effetti di 1-1,5% a 20 giorni.
5. **EMA "valida da 2n" (spec S17) contro "da n" (v2 punto 4):** la lettura coerente con v2 e **n** (v2 dice "seme SMA delle prime n barre; Trend N/A finche EMA 200 non e disponibile", e la data 2008-07-01 e scelta perche la EMA 200 W1 esista). Con 2n il Trend W1 e assente fino al 2012-03-12 (20% della lettura primaria). **L'esito non cambia** (C in entrambe, stessi stati dei cinque criteri); cambiano le grandezze. Gravita Media.
6. **Segnali di sottogruppo che meritano pre-registrazione** (esplorativi, trovati da me DOPO aver visto i risultati, nessuna conclusione): spread negativo DENTRO l'anno (-2,6% a 20 giorni, p di permutazione dentro-anno 0,0007) ma identico anche per i benchmark banali B1/B2; gradiente ex-ante per ATR (basso +1,5%, alto -2,4%, p 0,007 non corretto). Il +0,21% complessivo e un effetto di composizione fra anni, non un vantaggio interno.
7. Nel verdetto non ho trovato frasi piu forti dei numeri. Le quattro frasi del punto 16 ci sono tutte, ma la terza non porta il valore dell'MDE e manca il confronto con i benchmark (punto 8).

## 1. Cosa ho eseguito (evidenza)
| Verifica | Esito |
|---|---|
| `--autotest` in copia | 33 PASS, ESITO TUTTI PASSATI, 7,6 s |
| `studio_S1.py` in copia | 16 s, output identico al file consegnato; esito C |
| SHA256 congelamento | spec A2, bias_replica.py, D1_fuso.csv, studio_S1.py, prepara_dati.py, W1_fuso.csv: tutti OK |
| Ricalcolo indipendente (`indep.py`: ricostruisco D1 fuso dal CSV grezzo, leggo solo `score_A4.csv`) | N=5763, spread h=20 primaria +0,214% (A4: 0,214%), robustezza +0,740% (0,740%); t per offset 0,86/0,405/0,859/-0,326/0,489 (A4: mediana 0,49, min -0,33, max 0,86); metà -0,396% / +0,396% (coincidenza vera: -0,003960 e +0,003962); anni valutabili 12, positivi 3; episodi 122/99/221 e (b) 84/35; n non sovrapposti minimi 107/56. Tutto coincide. |
| Permutazione circolare indipendente (3000 shift, altro seme, con reinserimento) | p primaria 0,249 (A4: 0,267), robustezza 0,081 (A4: 0,091): differenza compatibile con l'errore Monte Carlo (circa 0,008 per parte). |
| Test del prefisso esteso (`prefix_all.py`): 980 date (lunedi e venerdi alterni, gap >= 4 giorni, primo e ultimo giorno d'anno, ultimo giorno) contro `score_A4.csv` | max diff 5,0e-11 (arrotondamento del CSV a 1e-10). Nessun look-ahead. |
| Equivalenza ramo di produzione (`only=None`) contro `only=lista` | 824 date, max diff 0 |
| Mutanti (copie, cancellabili) | vedi 2.1 |
| Analisi di sottogruppo (`sub.py`...`sub5.py`) | vedi 5 |

## 2. (a) Il codice di A4

### 2.1 Look-ahead e test di causalita
**Letto e a posto (con cosa ho controllato):**
- **EMA, ATR, RSI, MACD:** ricorsivi in avanti, seme su prime n barre; `first` del MACD dipende solo dalla lunghezza della serie, non dai valori. A posto.
- **Normalizzazioni:** nessuna statistica su campione intero. Volume: media a 20 barre (mobile). ATR: Wilder in avanti. Terzili ATR ex-ante: `bisect.insort` incrementale con minimo 250 giorni. A posto.
- **Swing:** i flag usano H[a+1..a+3], ma `_last2` li consulta solo per `a <= e-3`. Confermato dal mutante M4 (sotto): se si consulta `e-2` i test cadono.
- **BOS/CHoCH:** `_pattern(e)` per e = i..i-4 usa solo swing <= e-3 e C[e], C[e-1]. A posto. Nota: se nella stessa barra salgono sopra SH e sotto SL (up e dn insieme) `up` ha priorita: caso quasi impossibile (richiede SH < SL), non influente.
- **Regola W1 (v2 punto 3):** il ramo di produzione avanza `j` finche `wk[j].last_date < t`: il venerdi t vede le settimane fino a k-1, il lunedi la settimana k. Settimana accorciata (venerdi festivo): `last_date` e quella reale, quindi corretto. A posto.
- **Fusione domeniche:** la fusione e causale (T8c, e la domenica entra nel lunedi, mai nel venerdi precedente). Verificata a mano la riga 2026-10-18 + 2026-10-19 (T8b). A posto.
- **Rendimento `close[t+h]/open[t+1]-1`:** coperto da T11 (a mano, sintetico e reale con CSV grezzo) e dal mio ricalcolo indipendente (stessi spread/t). L'intervallo coperto e t+1..t+h, h barre, nessuna sovrapposizione fra osservazioni a passo h. A posto. Nota di realismo: per il venerdi t l'ingresso e l'open fuso del lunedi = open della domenica: eseguibile, ma il gap venerdi-domenica e escluso dal rendimento. Dichiarato nella fusione, non e look-ahead.
- **Fine campione:** `serie` usa `range(st, N-h)`; D1_fuso finisce 2026-10-16; barre 2026-10-19/20/21 escluse (3, come dichiarato). Ultimo t: 2026-10-09 (h=5), 2026-09-18 (h=20). A posto.
- **Welch, conteggio episodi, anni valutabili, ceil(0,6 x anni):** ricalcolati da me, coincidono. **Permutazione circolare:** lo shift si applica al vettore degli stati, il p e (1+ge)/(1+valid), unilaterale; la calibrazione sotto H0 (S6: 3/40 con p <= 0,05) e plausibile. A posto.

**Mutanti miei (copie in `scratchpad/a6_mut`, eseguito `--autotest` su ciascuna):**
| Mutante | Cosa cambia | Esito dei test |
|---|---|---|
| M4 | swing consultati con una barra di conferma in meno (`e-sw+1`: usa H[e+1]) | **T12 e T13 FALLISCONO** (diff 18). OK |
| M5 | look-ahead raro (una barra D1 su 97 usa il segno del giorno dopo nel price action) | **T12 FALLISCE** (3,57) e T3b (59 barre); T13 non lo vede (40 date). OK, ma mostra che T13 da sola e debole |
| M1b | W1 con `last_date <= t` in ENTRAMBI i rami | T9 e T12 FALLISCONO. OK |
| M2b | W1: la settimana corrente intera visibile dal lunedi, in ENTRAMBI i rami | T9, T12, T13 FALLISCONO. OK |
| **M2** | stesso look-ahead di M2b, **solo nel ramo di produzione** (`while`, `only=None`) | **TUTTI I 33 TEST PASSANO.** Il look-ahead di una settimana passerebbe il gate e lo studio partirebbe. |
| M1 | come M1b solo nel ramo di produzione | passa tutto |

**Obiezione 2-1 (Media).** *Punto:* `bias_replica.autotest` (T9, T10, T12, T13) usa `calcola_overall(..., only=...)`; `studio_S1.py` usa `calcola_overall(d1, params=...)` senza `only`. Sono due percorsi di codice diversi per la selezione della settimana W1. *Ragione:* una regressione nel ramo di produzione e invisibile al gate "lo studio non parte se un test fallisce". *Evidenza:* mutanti M1/M2: 33/33 PASS. Il codice oggi e giusto: equivalenza dei due rami max diff 0 su 824 date; test del prefisso di 980 date contro il file di produzione: 5e-11. *Modifica richiesta:* aggiungere al gate un test di equivalenza ramo produzione / ramo `only` (o fare passare il test del prefisso sul `score_A4.csv` appena scritto). Il file e congelato: o si registra come controllo esterno (il mio, ripetibile: `prefix_all.py`) o nuova decisione con nuovo SHA e nuova esecuzione. Per un verdetto C non e bloccante; per un eventuale A sarebbe necessario.

**Obiezione 2-2 (Bassa).** *Punto:* la potenza dei test di causalita: T12 usa 327 date casuali (3 venerdi, 3 lunedi, ultimo giorno) e T13 solo 40. *Ragione:* un look-ahead che tocca l'1% dei giorni viene mancato da T12 con probabilita circa e^-3,3 = 4%, e da T13 circa 67%. *Evidenza:* M5 preso da T12, non da T13. *Modifica:* nulla di bloccante; il mio test su 980 date mirate (inclusi lunedi/venerdi/festivi/capodanno) copre il rischio. Citarlo come controllo.

### 2.2 Altri difetti del codice
**Obiezione 2-3 (Bassa).** *Punto:* criterio 1, precedenza FAIL su NV. In `valuta_segnale`, `sp <= 0` da FAIL anche se lo stato non e valutabile. *Ragione:* v2 punto 6 dice "non valutabile, non fallito". *Evidenza:* lettura primaria, `h20_b`: BEAR n non sovrapposto minimo 8 (< 30), "valutabile NO", ma criterio 1 `h20_b = FAIL`; nella robustezza lo stesso caso e NV perche lo spread e positivo (+0,296%): lo stesso stato non valutabile cambia etichetta col segno del rumore. *Effetto sull'esito:* nullo, perche `h5_b` e valutabile (BEAR 34 non sovrapposti, 35 episodi) e fallisce davvero (spread -0,68%, t mediano -1,15). *Modifica:* nel testo del verdetto scrivere `h20_b = NV` (non FAIL); nessuna riesecuzione.

**Obiezione 2-4 (Bassa).** *Punto:* etichetta fuorviante nell'intestazione di `studio_S1_ext_output.txt` ("EMA valida da 2*n barre" con score esterno di A7). *Ragione:* il parametro vale solo per il benchmark B1 in quella corsa. *Modifica:* riga di nota nel verdetto. Nota utile: la corsa esterna (score di A7) da anch'essa C (primaria: metà -0,093% / +0,428%, t mediano 0,63, p 0,21; robustezza p 0,13), il che indica che C non dipende dall'implementazione. Ma in quella corsa il gate NON ha eseguito i test di causalità di A7 (lo dice l'output): per v2 punti 2 e 10 non vale come verdetto di A7 finché A7 non li esegue.

**Obiezione 2-5 (Bassa).** *Punto:* il testo v2 punto 4 dice che dal 2010-04-01 il "peso del seme residuo e trascurabile". *Ragione:* per la EMA 200 W1 con seme SMA, il peso del seme a 2010-04 e circa 0,99^104 = 35% (a 1% solo dopo circa 460 settimane, cioe dal 2017). Il mio stesso O3 precedente (12% a 212 barre, 5% a 300) valeva per seme = primo valore, non SMA. *Effetto:* il seme SMA(200) e un livello ragionevole (non e un valore iniziale arbitrario), quindi l'errore di livello e modesto; la lettura "robustezza" non e libera dal seme su W1. *Modifica:* una riga nel verdetto: "robustezza = taglio dei primi 21 mesi (2008-07/2010-03), non eliminazione del seme". Nessuna riesecuzione.

**Controlli senza difetti:** T3b (simmetria specchio sul D1 reale: 0 barre fuori tolleranza su 5750); T4a/b (invarianza di scala/traslazione); T5 (volume N/A); T6 (zigzag a mano); T7 (quadro e alert); T10 (buffer 5000 barre); conteggio barre fuse 5766 con 1084 domeniche. Tutti letti e coerenti con la specifica; non rilevanti per S1 la confidenza, il contro-trend e gli alert (non usati dallo studio).

## 3. (b) Le regole R1-R10

| Regola | Giudizio | Puo spostare l'esito? |
|---|---|---|
| R1 spread su tutti i giorni, h=5 e 20, (a) e (b) | Ragionevole, uguale a v2 punto 7. Vedi 2-3 sulla precedenza FAIL/NV. | No |
| R2 Welch non sovrapposto, offset v2, posizione nella serie dei giorni validi | Ragionevole. Ricalcolata: coincide. | No |
| R3 permutazione: statistica = mediana dei t, 3000 shift in [60, N-60], p = (1+ge)/(1+valid) | Ragionevole e coerente col criterio 2 (stessa statistica). Alternativa (spread su tutti i giorni, che avevo proposto io): p 0,336 (primaria), 0,128 (robustezza); con la mediana dei t: 0,267 e 0,091. Nessuna dei due <= 0,05. Ricalcolo mio: 0,249 e 0,081. | No (mai <= 0,05) |
| R4 stato valutabile: MIN sugli offset di n >= 30 e episodi >= 8 | Ragionevole, piu severo della mediana, coerente con v2 punto 6. Verificato 107/56 (a), 32/8 (b, h=20). | No |
| R5 anno valutabile: >= 20 giorni BULL e >= 20 BEAR (a, h=20) | Letterale v2 punto 7. Nota: 2008 (solo luglio-dicembre) e 2026 (fino al 18/9) contano come anni. Ricalcolato: 12 valutabili, 3 positivi; escludendo i due parziali sarebbero 3 su 10 con soglia 6. | No |
| R6 criterio 5: t di Welch di BULL contro NON-BULL, mediana degli offset | Ragionevole (BULL contro "tutti" non e indipendente). t = 0,32 (prim.) e 0,76 (rob.): sotto 1,0 in ogni caso. | No |
| R7 MDE = 2,8 x SE di Welch; **potenza sufficiente se MDE(h=20,a) <= abs(deriva a 20 giorni)** | **Non ragionevole come criterio di B.** Vedi 3.1. | **Si: rende B impossibile** |
| R8 esito A / B / C | Coerente con v2; l'unico problema e la dipendenza da R7. | Solo via R7 |
| R9 benchmark B1/B2 con la stessa macchina, solo definizione (a) | Ragionevole. B1 usa EMA valida da 400 barre D1: irrilevante dal 2008. | No |
| R10 regimi ex-post (LONG >= +10%, SHORT <= -5%, 2009-2025), terzili ATR espansivi, segno 250 giorni | Soglie arbitrarie ma dichiarate prima e solo descrittive. La cella SHORT ha 2 anni e 4 episodi BULL: non interpretabile (A4 lo mostra). | No |

### 3.1 R7 e potenza (Alta)
*Punto:* R7 definisce "potenza sufficiente" come MDE(h=20,a) <= abs(deriva incondizionata a 20 giorni) della stessa lettura. B si ottiene solo con un criterio FAIL "in lettura con potenza sufficiente".
*Ragioni:* (1) **E irraggiungibile.** MDE = 2,8 x SE; per MDE <= 0,73% serve SE <= 0,26%; con sigma a 20 giorni 4,7% servono circa 657 osservazioni non sovrapposte PER STATO (circa 13.000 giorni per stato), contro 107/56 (primaria) e 95/52 (robustezza): il campione intero (4.712 giorni = 235 osservazioni non sovrapposte) e 6-10 volte troppo piccolo anche se tutti i giorni stessero in uno solo dei due stati. Quindi per qualunque dato che non produca t <= -2 (regola 14) l'esito e C: il verdetto e deciso da R7, non dai numeri. (2) **La soglia e dei dati, non del segnale:** la deriva e quella dell'oro 2008-2026 (0,73%); in un periodo senza deriva la soglia diventerebbe 0 e C sarebbe automatico; la stessa deriva compare nei benchmark e non dice quale spread sia utile. (3) A6 aveva scritto nella v1 che serviva uno spread di 2-3 volte la deriva per t >= 2: R7 chiede di poter rilevare uno spread PARI alla deriva, un requisito ancora piu duro e senza motivazione di dominio.
*Evidenza:* MDE h=20(a): 2,208% (prim.), 2,100% (rob.) contro deriva 0,733% e 0,697%. Mia stima con la distribuzione di permutazione: sd nulla dello spread 0,65% (primaria), MDE 1,83%; robustezza 0,66% e 1,86%. IC95 approssimato dello spread: primaria +0,21% [-1,07%; +1,50%], robustezza +0,74% [-0,56%; +2,04%]; h=5 primaria +0,02% [-0,32%; +0,36%].
*Modifica richiesta:* **non cambiare il verdetto C**, ma riscrivere la motivazione. Dire esplicitamente che sotto R7 B non e raggiungibile con questo campione, riportare l'IC dello spread e cosa esclude (a 95%: spread medio sopra circa +1,5% a 20 giorni e sopra circa +0,36% a 5 giorni nella lettura primaria), e in una futura v3 sostituire la soglia con un effetto minimo rilevante dichiarato in anticipo (per esempio il pareggio dopo costi) o con un test di equivalenza. Aggiungere la frase: "C non e il risultato dei dati ma del disegno: nessun campione di questa lunghezza avrebbe potuto produrre B".

### 3.2 EMA valida da 2n (spec S17) contro n (v2 punto 4) (Media)
*Coerenza con v2:* v2 punto 4 dice "EMA con seme SMA delle prime n barre; il Trend e N/A finche EMA 200 non e disponibile"; con seme SMA la EMA e disponibile alla barra n. Inoltre la lettura primaria parte il 2008-07-01 perche la EMA 200 W1 esista (il mio O3: "quando EMA 200 W1 esiste davvero"): con n il Trend W1 compare il 2008-05-12, con 2n il 2012-03-12. **Quindi la lettura coerente con v2 e n.** La specifica A2 (S17) dice 2n ed e anch'essa congelata (v2 punto 9): i due documenti sono in conflitto e A4 ha applicato la specifica come "primaria" e n come "variante". E accettabile come trasparenza, ma contraddice l'intenzione di v2.
*Esito cambia?* **No.** Stati dei criteri identici in entrambe le letture e in entrambe le corse (primaria 1-5 tutti FAIL; robustezza FAIL, FAIL, OK, FAIL, FAIL); C in entrambe. Cambiano le grandezze (primaria, h=20 (a)): spread 0,214% -> 0,365%, t mediano 0,49 -> 0,75, p 0,267 -> 0,180; prima meta -0,396% -> -0,055%; quota BEAR 24,9% -> 23,7% (A7 misura 24,0% BEAR e 49,2% BULL, cioe piu vicino a n: 49,6%; con 2n 47,3%). Robustezza: spread 0,740% -> 0,784%, p 0,091 -> 0,085.
*Modifica richiesta:* nel verdetto presentare le due corse come equivalenti ("dipende dalla scelta: identico verdetto") e chiedere a C0 una decisione formale (D003) su quale sia la primaria; non serve riesecuzione perche i file `studio_S1_varN_*` esistono gia, sono stati prodotti dallo script congelato (l'opzione `--ema-valid-mult` e nello SHA) e dal CHANGELOG risulta pre-dichiarata.

## 4. (c) Il verdetto "C, NON CONCLUSIVO (potenza)"
**E giustificato dai numeri?** Si, con la correzione del 3.1.
- **Non e A:** primaria 1-5 tutti FAIL (spread (b) negativo a h=5 e h=20; t mediano 0,49 con p 0,27; meta 1 negativa; 3 anni positivi su 12 con soglia 8; t di eccesso 0,32). Robustezza: solo il criterio 3 passa.
- **Non e la regola 14:** nessun t <= -2. Il piu negativo e `h5_b` con t mediano -1,15 (minimo -1,82); p di permutazione negativo 0,095 (`h5_b`) e 0,161 (`h20_b`).
- **Non e B** perche B richiede potenza sufficiente e, con qualunque soglia sensata (non solo R7), la potenza e insufficiente: MDE 2,2%/20 giorni (1,8% con la permutazione) contro un possibile effetto utile dell'ordine di 0,5-1%.
- **C e cosi il verdetto prudente giusto**, ma "non conclusivo" e meno informativo di quanto i dati permettano: l'effetto puntuale (+0,2%/20 giorni, +0,02%/5 giorni) e a zero e l'IC esclude effetti grandi. Va scritto.
- **Stronger?** Non per i criteri. L'unica cosa "piu forte" sarebbe lo spread interno agli anni negativo (sezione 5), ma e esplorativa, non e uno dei criteri e vale anche per i benchmark: non va nel verdetto, va in una pre-registrazione.

**Frasi piu forti dei numeri:** non ne ho trovate. Il testo non dice "il bias non funziona" ne "nessun vantaggio" senza il qualificatore del punto 16. `CHANGELOG.md` dice "entrambe danno esito C" (vero).

**Frasi obbligatorie (v2 punto 16):**
1. "verdetto sulla replica, non validata contro l'originale": presente (inizio e fine).
2. "solo oro, W1+D1, orizzonte giornaliero, 5 e 20 giorni": presente.
3. "nessun vantaggio dimostrato non significa nessun vantaggio" **con l'MDE**: la frase c'e, ma nel blocco di esito ("=== 5. ESITO") non porta alcun numero; l'MDE e stampato solo piu in alto per lettura.
4. "nessuna regola EA tarabile su questi dati": presente, piu "nessuna regola EA da proporre".

**Obiezione 4-1 (Media).** *Punto:* il blocco di verdetto non quota l'MDE e non riporta il confronto coi benchmark (v2 punto 8: "il confronto con i benchmark e parte del verdetto"). *Evidenza:* sezione 3 dell'output ha B1 spread h=20 +0,129% (t 0,42; robustezza +0,432%, t 0,81), B2 +0,037% (t -0,20; +0,418%, t 0,60) contro replica +0,214% (t 0,49; +0,740%, t 1,22): la replica non e distinguibile dai due benchmark banali; ma l'esito (blocco 5) non lo dice. *Modifica:* aggiungere al verdetto: MDE h=20(a) 2,21% (prim.) / 2,10% (rob.), h=5(a) 0,59% / 0,54%; IC dello spread (3.1); tre righe con il confronto B1/B2; la dicitura "lato A4: l'esito di A7 e l'accordo A4/A7 sono separati".

**Obiezione 4-2 (Bassa).** *Punto:* il verdetto non dice che il criterio 3 dipende da 21 mesi. *Evidenza:* prima meta -0,396% (primaria, parte 2008-07) contro +0,456% (robustezza, parte 2010-04): il segno cambia togliendo luglio 2008-marzo 2010 (2008 -13,3%, 2009 -8,0% per anno). *Modifica:* una riga "criterio 3 sensibile alla scelta della data di inizio".

## 5. (d) Esito neutro o ci sono segnali? Ipotesi da pre-registrare (senza concludere)
**Premessa:** quanto segue l'ho cercato io, dopo aver visto i numeri di A4, guardando le tabelle per anno/regime/ATR gia nell'output. Sono segnali ESPLORATIVI con piu tagli (almeno 8: anni, tre regimi ex-post, tre terzili ATR, due segni a 250 giorni): nessun p qui e corretto per i confronti multipli. Non cambiano il verdetto.

**Fatto di struttura (A4 lo mostra ma non lo commenta).** Lo spread complessivo e +0,21%, ma: per anno solo 3 anni su 12 sono positivi; per regime ex-post LONG -3,09%, SHORT -5,49%, LATERALE -0,44% (tutti negativi); senza 2025-2026 lo spread diventa -0,16%. E una composizione: gli stati BULL cadono negli anni forti (2024 e 2025 solo BULL, 0 BEAR), i BEAR negli anni deboli (2013-2015).

**H-A: spread negativo dentro l'anno (contrarian).**
- *Evidenza:* spread stratificato per anno (peso armonico dei due stati, h=20, primaria) = **-2,58%** (-2,05% senza 2008; -2,06% senza 2008, 2025, 2026); prima parte 2008-2016 -3,85%, seconda 2017-2026 -1,56% (stesso segno). Permutazione circolare DENTRO ogni anno (shift >= 20 giorni, 1500 permutazioni): p unilaterale per segno negativo **0,0007**. Simulazione di controllo con rendimenti iid e gli stati reali: spread stratificato medio +0,09%, sd 0,93%: il reale e a -2,9 sd, e l'etichettatura ex-post dei regimi non produce un effetto meccanico (spread medio per regime ex-post circa 0 su 300 simulazioni).
- *Pero:* **lo stesso effetto e nei benchmark banali**: B1 (close contro EMA 200 D1) -3,15%, B2 (rendimento a 250 giorni) -2,67%; segno del rendimento a 20 giorni -0,54%, a 60 giorni -1,17%. Quindi e una proprieta degli stati lenti di trend sull'oro (ribassi seguiti da rimbalzi: 2008-2009, 2013, 2015, marzo 2020), non dell'indicatore. Pochi episodi indipendenti dominano.
- *Ipotesi da pre-registrare:* "su dati nuovi (forward da 2026-10-22, altri strumenti), lo spread BULL-BEAR stratificato per anno solare, h=20, e < 0 per la replica e per B1/B2; criterio di falsificazione: IC95 dello spread stratificato contiene 0 o e > 0." Test: permutazione dentro-anno; stratificazione dichiarata prima; l'ipotesi riguarda gli stati di trend lento, non la replica.

**H-B: gradiente ex-ante per volatilita (ATR 14 D1 / close, terzili espansivi).**
- *Evidenza (primaria, h=20 (a)):* ATR basso spread **+1,53%** (BULL 874 / BEAR 435 giorni, t mediano non sovrapposto 1,76), ATR medio +0,59% (t 0,83), ATR alto **-2,42%** (511/310, t -1,32). Differenza basso-alto +3,95%; permutazione circolare delle etichette ATR (shift >= 60, 1500): p **0,007**, non corretto per almeno 5-6 tagli (Bonferroni circa 0,04). Stesso ordine nelle due meta (basso +2,75% / +0,17%; alto -5,78% / -0,60%) ma la seconda e molto piu debole. Lettura robustezza: basso +1,50%, alto -0,61%.
- *Ipotesi da pre-registrare:* "lo spread di BULL-BEAR a 20 giorni e maggiore in regimi di bassa volatilita ex-ante (ATR14/close nel terzile inferiore storico) che in alta (terzile superiore); direzione prefissata: basso > alto." Falsificazione: differenza <= 0 su dati nuovi. Terzili espansivi, minimo 250 giorni, come in A4.

**H-C (debole): BEARISH deciso (|S| >= 50) seguito da rimbalzo.** h=5: BEAR 1,04% contro BULL 0,36%, spread -0,68%, t mediano -1,15, p negativo 0,095, 35 episodi; robustezza -0,22%, t -0,39. Non regge nella robustezza (h=5 spread negativo, ma t -0,39 e h=20 positivo +0,30%). Ipotesi solo se un'ipotesi piu ampia (H-A) viene confermata: nessuna pre-registrazione autonoma.

**Giudizio:** il risultato non e "neutro" nel senso di nullo ovunque: e nullo nel pooled e nei benchmark, ma ha una struttura interna (composizione fra anni) che e un'informazione utile alla decisione EA ("il bias non e un filtro con vantaggio medio, e rispecchia il regime"). Non va concluso su questo campione, che e l'unico che abbiamo e su cui H-A e H-B sono state scelte: servono dati nuovi e una pre-registrazione prima di guardarli.

## 6. Correzioni raccomandate prima della consegna
Nessuna richiede di rieseguire lo studio (le cifre sono confermate), salvo la 3 se si vuole il test di equivalenza dentro il codice.
1. **(Alta)** Riscrivere la motivazione di C: sotto R7 B e irraggiungibile (servono circa 657 osservazioni non sovrapposte per stato); riportare IC dello spread e cosa esclude; frase "C non e il risultato dei dati ma del disegno". Proporre per una v3 un effetto minimo rilevante dichiarato in anticipo o un test di equivalenza al posto di R7.
2. **(Media)** Verdetto: quotare l'MDE (h=20(a) 2,21%/2,10%; h=5(a) 0,59%/0,54%) accanto alla terza frase obbligatoria; aggiungere il confronto B1/B2 (replica non distinguibile); dichiarare "lato A4" e che A7 e l'accordo sono separati.
3. **(Media)** Segnalare e chiudere il buco dei test: il gate non percorre il ramo di produzione. Registrare il mio controllo (`prefix_all.py`, 980 date, 5e-11) o aggiungere il test di equivalenza con nuova decisione/nuovo SHA. Obbligatorio prima di qualsiasi verdetto A.
4. **(Media)** EMA 2n contro n: chiedere a C0 una decisione (D003) sul conflitto fra specifica S17 e v2 punto 4; nel verdetto presentare le due corse come equivalenti (stesso C, stessi stati dei criteri, grandezze diverse); dichiarare che con 2n il Trend W1 manca fino al 2012-03-12.
5. **(Bassa)** Chiamare `h20_b` della lettura primaria "NV" (non "FAIL"), come vuole v2 punto 6; l'esito non cambia.
6. **(Bassa)** Aggiungere al verdetto: criterio 3 sensibile alla data di inizio (21 mesi: -0,396% contro +0,456%); la robustezza dal 2010-04 non elimina il peso del seme su W1 (circa 35% a 2010-04 con seme SMA); la corsa "ext" di A7 non ha test di causalita finche A7 non li esegue.
7. **(Bassa)** Aggiungere una sezione "Ipotesi esplorative da pre-registrare, NON concluse": H-A, H-B (e H-C come nota), con la dichiarazione che sono state trovate da A6 dopo i numeri, con piu tagli e senza correzione per confronti multipli.

## 7. Cosa NON ho trovato (voci a posto, per non inventare conflitti)
- Nessun look-ahead in swing, BOS, EMA, volume, price action, W1, fusione, rendimenti (lettura + mutanti + 980 date).
- Nessun errore nel calcolo `close[t+h]/open[t+1]-1`, nel conteggio degli episodi (122/99/221, 84/35 ricalcolati), nell'esclusione dell'ultima settimana, nelle metà cronologiche, negli anni valutabili (12/11 e soglia 8/7), nel t di Welch, nella permutazione (p compatibili entro l'errore Monte Carlo).
- La coincidenza -0,396%/+0,396% delle due metà e vera (-0,003960 / +0,003962 nel mio ricalcolo), non un errore di segno.
- Cronologia di A4 (CHANGELOG): il congelamento (09:38:30) precede la corsa (09:41); il parametro `--ema-valid-mult` e dentro lo script congelato; le uniche modifiche dopo i primi test sono errori del test, dichiarati.
