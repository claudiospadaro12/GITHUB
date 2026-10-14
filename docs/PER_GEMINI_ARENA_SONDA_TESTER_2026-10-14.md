# PER GEMINI -- EA-M1 nel nostro Strategy Tester: prima sonda di UN giorno (28/09/2026), tre domande chiuse -- 14/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` e `docs/gemini/PROTOCOLLO_MARKET_2026-10-13.md` (arrivano insieme a questo file, con la memoria condivisa e la BASE) e la regola di casa dell'11/10: uno zip di misura letto genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata. Ne facciamo **tre**, tutte al **ruolo B** (avvocato del diavolo: costruisci il contro-esempio, non confermare).
Niente preset, righe o script di lancio, numeri di conto o magic, chiavi, nome del venditore o del prodotto in questo documento. L'EA si chiama **EA-M1**: griglia con ordini stop e recupero a lotti progressivi sull'oro, prodotto di terzi a scatola nera (nessun sorgente; non si decompila e non si aggira nulla, e tu non devi suggerirlo). Non cercare ne' indovinare quale prodotto sia.
Etichette nostre: **[MISURATO]** letto da noi in un report del tester; **[DERIVATO]** conto su numeri misurati; **[INFERITO]** ragionamento nostro, non verificato; **[DICHIARATO DA TERZI]** non verificato; **[NON MISURATO]** il numero non esiste.
Fonti nel repo (branch `lavoro`): la lettura del 14/10 (`report/ARENA_TESTER_SONDA_LETTURA_2026-10-14.md`, sez. 1-4) e l'uscita completa del lettore (`backtest_pipeline/risultati_archivio/ARENA_TESTER_SONDA_20261014/LETTURA_USCITA.txt`, con `SONDA1_cesti.csv` e `SONDA1_giorni.csv` nella stessa cartella). Le attese e le alternative del lettore erano scritte PRIMA dei numeri.

**Come rispondere** (ruolo B): tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. «NON LO SO» e' una risposta valida e preferita a un numero inventato. Un contro-esempio vale solo se porta i NUMERI: quale cifra, nei dati descritti qui, produrrebbe la tua spiegazione alternativa e se cade dentro la nostra banda.

---

## 0. ATTENZIONE: il giro NON e' quello dichiarato, e il lettore NON da' verdetto
- **La condizione dichiarata prima dei numeri era leva 1:500; il report del tester dice leva 1:100** [MISURATO: report del tester, riga «leva 1:100»; il file di configurazione chiedeva 500]. Per regola scritta prima dei numeri, un giro diverso da quello dichiarato **non da' verdetto**: il lettore stampa «(A)(B)(C) NESSUN verdetto». Non l'abbiamo ammorbidita dopo aver visto i numeri.
- Tutto cio' che segue e' quindi **DESCRITTIVO di QUEL giro (1:100)**. Non e' una misura della condizione dichiarata, non e' un verdetto, una promozione o un'archiviazione di EA-M1.
- Il lettore non da' alcuna conclusione sul merito (campione: un giorno, un regime, operazioni da un solo cesto che pesa quasi tutto).

## 1. Il motore e le condizioni di misura, in tre righe
- **Motore** [natura letta su un conto demo nostro, scatola nera]: griglia con ordini stop su due lati; recupero «a cesto» con lotti progressivi; **nessuno stop iniziale** sulle posizioni; altri due moduli piccoli (chiamiamoli F1 e F2) con poche posizioni.
- **Condizioni** [MISURATO, report del tester]: oro, M1, qualita' 100% tick reali (272.740 tick in 872 barre), feed del nostro broker, **un solo giorno: 28/09/2026 (data server)**, **partenza da conto VUOTO** (nessuna posizione pre-esistente), deposito 5.000 EUR, lotto base 0,01, modalita' di esecuzione senza latenza ne' slippage, commissione per lotto addebitata dal tester. Due impostazioni a scelta dell'EA non imposte da noi: usato il valore di default del tester, letto dal report.
- **Perche' proprio il 28/09**: la data e' stata scelta perche' un terzo [DICHIARATO DA TERZI, non verificato, nessun importo qui] sostiene che quel giorno un conto con questo EA ha perso quasi tutto. Il giorno quindi **non e' campionato a caso**: e' scelto da noi dopo aver letto un'accusa.

## 2. I numeri [MISURATO, tutti dal report del tester e dal lettore; fonte: LETTURA_USCITA.txt, sezioni RISULTATO / CESTI / PER GIORNO]
| voce | valore |
|---|---|
| operazioni (ingressi) | 111 |
| netto realizzato | **-3.351,18 EUR (-67,0% del deposito)** |
| fattore di profitto | 0,04 |
| DD di equita' massimo (report) | 3.362,84 EUR (67,10%) |
| saldo finale | 1.648,82 EUR |
| **stop out del conto del tester** | **14:31:00 server, livello di margine 49,40%** (6 deal di stop out) |
| lotti d'ingresso totali / picco lotti vivi | 1,53 / 0,42 (buy 0,38; sell 0,09) |
| ingressi da ordine pendente eseguiti al prezzo dell'ordine | 15 su 111 (13,5%); gli altri 96 a prezzo PEGGIORE (massimo 12,84 USD, media dei peggiori 0,439), nessuno migliore. Nel tester non c'e' latenza: e' un salto fra due tick. Nel conto demo nostro 731 su 731 ingressi erano esatti [MISURATO nel censimento del demo] |
| commissione addebitata | 3,88 EUR per lotto a giro, distorta verso l'alto dall'arrotondamento al centesimo a 0,01 lotti; atteso ~3,90 [NON VERIFICATO] |

**Cesti di recupero** (APPROSSIMATI: in 22 uscite su 111, il 19,8%, l'accoppiamento ingresso-uscita e' ricostruito e ambiguo, quindi i netti PER CESTO sono approssimati; i netti per giorno no) [MISURATO]:
| profondita' (livelli) | cesti | netto EUR | somma lotti (max) |
|---|---:|---:|---:|
| 1 | 14 | +24,00 | 0,02 |
| 2 | 6 | +25,24 | 0,04 |
| 3-4 | 2 | +21,11 | 0,08 |
| 5-9 | 0 | -- | -- |
| **>= 10** | **1** | **-3.357,08** | 0,37 |
- Il cesto da 10 livelli e' un **buy**, aperto alle 00:52 e chiuso dallo stop out alle 14:31 (**13,6 ore** vivo), somma lotti 0,37. Gli ingressi chiusi dallo stop out erano buy a circa 4.251, 4.231 e 4.227.
- **Concentrazione**: i cesti a >= 10 livelli valgono **-3.357,08 = 102,1% del netto del modulo di recupero (-3.286,73 su 23 cesti)**; i 22 cesti restanti sommano +70. Sul conto demo nostro, in due giorni (13/10 e 14/10), la stessa quota era 24,5% e 50,8% del netto del modulo di recupero [MISURATO nel censimento del demo].
- Moduli F1 / F2: 61 posizioni, netto -67,67, PF 0,42 / 7 posizioni, netto +3,22, PF 2,79.
- **Valore del punto** [DERIVATO]: 88 EUR per 1,0 di prezzo per 1 lotto (mediana di 80 posizioni accoppiate). A 0,37 lotti sono ~32,6 EUR per punto: -3.357 corrisponde a una media di circa 103 punti di prezzo contro la posizione.
- Giornale: modifiche di SL/TP rifiutate «vicino al mercato» (codice 10029) alle 00:40:26-27, ripetute.

## 3. Fatto del nostro archivio che riguarda la Q1 [MISURATO da noi in un altro round, 27/08/2026]
In un round di 27/08 il file di configurazione del tester chiedeva leva 15 e il tester ha stampato leva **100** su **tre** simboli; molti nostri file di configurazione standard dichiarano gia' 100. Un altro conto demo nostro e' dichiarato 1:500 in un piano [DICHIARATO da noi in un documento, non misurato]; la leva del conto demo del terminale su cui gira la sonda **non e' stata letta** [NON MISURATO]. Non sappiamo se il tester prenda la leva dal file di configurazione (ignorato), dal conto o dal server.

## 4. Quello che NON si puo' concludere (nostra lettura)
- Un giorno, un regime, un feed, un solo cesto profondo: **non e' la frequenza del crollo**.
- [INFERITO, non misurato] Con leva 1:500 lo stop out sarebbe arrivato piu' tardi o non arrivato: la perdita flottante e' la stessa, il margine richiesto no. Il livello di stop out del server non e' letto da noi [NON MISURATO].
- Tester senza latenza ne' slippage: nel reale ci aspettiamo peggio (un recensore dichiara ordini non eseguiti [DICHIARATO DA TERZI]).
- Nessun merito. Griglia + scala di lotti + recupero senza stop iniziale resta fuori dai nostri cancelli per le prop; non e' un verdetto.
- **Verdetto di casa su questo pacchetto: NESSUN VERDETTO** (giro non conforme alla condizione dichiarata).

---

## 5. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q1 (ruolo B) -- Da dove prende la leva il tester, e quale prova a costo zero separa le spiegazioni?**
Dato che la motiva: sez. 0 e sez. 3. Chiesta 500, ottenuta 100; stessa cosa nel round di agosto (chiesta 15, ottenuta 100).
Spiegazioni in gara: (a) il tester usa la leva del CONTO (del terminale/server) e ignora il file di configurazione; (b) il file di configurazione e' letto ma il server impone un tetto (per gruppo, per simbolo, a scaglioni di equity o di esposizione); (c) il report stampa la leva del conto ma il margine nel tester e' calcolato con un'altra; (d) un'altra spiegazione tua.
Domanda: per ciascuna spiegazione, **quale numero** (leva letta dal conto demo; margine richiesto per 1 lotto dello stesso simbolo nel tester confrontato con prezzo x dimensione contratto / leva; margine del test con un altro simbolo) la rende vera o falsa, e quale misura a costo zero (sola lettura, nessuna corsa del tester) le separa? Dove sbaglia la nostra attesa?
Nostra attesa [INFERITO]: (a). Se la leva letta sul conto demo e' 100, la sonda a 1:100 era il giro corretto e andava solo dichiarata cosi'; se e' 500 e il tester stampa ancora 100, (a) e' falsa. Contro-esempio nostro: se il margine per 1 lotto nel tester equivale a prezzo x contratto / 500, la leva stampata nel report non e' quella usata.

**Q2 (ruolo B) -- Evento raro o regola: quale misura minima, senza griglia di parametri?**
Dato che la motiva: sez. 2: un solo cesto da >= 10 livelli = 102,1% del netto del modulo di recupero, stop out al 49,40% di margine, nella sola giornata del 28/09 (scelta dopo un'accusa di terzi, sez. 1). Sul demo, quota dei cesti a >= 10 livelli: 24,5% e 50,8% in due giorni. Il giorno del 28/09 ha richiesto 467 secondi di test [MISURATO]; la corsa del trimestre luglio-settembre e' stimata in 509 minuti [STIMA NON MISURATA: ~65 giorni di borsa x 467 s], oltre il timeout di 240 minuti, quindi va spezzata. Proposta nostra: tre tranche mensili (luglio, agosto, settembre; circa 170 minuti ciascuna [STIMA]) con leva dichiarata PRIMA, partenza da conto vuoto in ognuna.
Domanda: **qual e' la misura minima** (cosa contare per tranche, con quale soglia scritta prima dei numeri) che separa «evento raro» da «regola», senza cambiare nessun parametro dell'EA? Dai l'attesa con la banda E il numero che darebbe l'ipotesi alternativa, e dimmi se le tre tranche bastano o sono troppo poche (quante osservazioni indipendenti di «cesto profondo» ci sono davvero).
Nostra attesa [INFERITO]: senza nessun cesto >= 10 livelli in ~65 giorni, il limite superiore al 95% della frequenza per giorno e' circa 3/65 = 4,6% [CALCOLO, regola del tre]; con uno o piu' cesti profondi, contare per ciascuno profondita', durata, lotti vivi e se arriva allo stop out. Contro-esempio nostro: ogni tranche riparte da conto vuoto, quindi un cesto aperto a fine mese precedente (e il suo gap del fine settimana) non c'e' nella tranche successiva: le tre tranche NON equivalgono a un trimestre continuo.

**Q3 (ruolo B) -- Dove sbaglia la lettura «a 0,01 lotti il cesto profondo uccide un conto da 5.000 con margine 1:100»?**
Dato che la motiva: sez. 2 e sez. 4. La frase e' la nostra sintesi [INFERITO] di un giorno di test.
Domanda: costruisci il contro-esempio. Quali di questi fattori (o altri tuoi) potrebbero far sbagliare la frase, e **quale numero**, nei dati descritti qui, lo mostrerebbe: (1) la partenza da conto vuoto e l'assenza di cesti pre-esistenti; (2) lotto minimo e passo di lotto del simbolo (a 0,01 le progressioni del recupero si arrotondano); (3) commissioni (arrotondamento al centesimo a 0,01 lotti); (4) lo spread e il feed del nostro broker rispetto a quello dell'utente; (5) il livello di stop out del server (49,40% e' il livello a cui scatta il primo deal, non e' detto sia il livello del server); (6) la data scelta dopo un'accusa di terzi (selezione del giorno); (7) l'ambiguita' dell'accoppiamento in 19,8% delle uscite (netti per cesto approssimati: puo' cambiare il 102,1%?).
Nostra attesa [INFERITO]: la frase regge come descrizione di QUEL giro, non come frequenza ne' come giudizio sull'EA. Contro-esempio nostro: i netti per giorno e i lotti vivi non dipendono dall'accoppiamento; solo la quota 102,1% e il peso del singolo cesto ne dipendono.

---

## 6. Vincoli (dal protocollo, ricordati)
- Non suggerire di decompilare, intercettare o aggirare il prodotto; se un dettaglio non e' osservabile scrivi NON LO SO e dillo come dato mancante.
- Non proporre griglie di parametri sul motore ne' cambiare taglie, rischio o conti. Non chiamare nulla «promosso/bocciato».
- La tua risposta e' DATI: passa dal nostro cancello punto per punto contro il repo; nessuna tua frase e' un criterio. Due macchine che si contraddicono = una misura da fare, non un compromesso.
