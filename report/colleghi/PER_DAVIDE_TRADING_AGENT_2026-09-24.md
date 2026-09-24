# Trading Agent: osservazioni e spunti

**Per Davide Nevodini, da Claudio Spadaro. Settembre 2026.**

Ho letto il dossier del progetto con attenzione. Qui sotto trovi cosa mi ha colpito, cosa porterei anche nel nostro lavoro e qualche idea che, secondo la nostra esperienza, potrebbe accorciarti la strada. Sono osservazioni di metodo: niente dati, parametri o risultati nostri.

---

## 1. Cosa funziona già molto bene

- **La separazione fra chi ragiona e chi calcola.** Tenere gli indicatori fuori dall'IA e affidarli a un calcolatore deterministico è la scelta giusta. Noi siamo arrivati alla stessa regola dopo aver visto numeri plausibili ma sbagliati.
- **"Un dato mancante si dichiara, non si riempie."** È il principio che salva più giornate di tutti. Noi lo scriviamo come *NON MISURATO* accanto a ogni numero che non abbiamo davvero.
- **Lo scenario come unità di lavoro**, con ingresso, obiettivo e invalidazione obbligatori. Uno scenario incompleto che non viene mai presentato come pronto è disciplina vera.
- **Le tre barriere contro l'operatività**, soprattutto la seconda: i comandi di trading vietati a monte, a prescindere da quello che decide l'IA. È più robusta di qualunque istruzione scritta.
- **La verifica dell'orologio dopo ogni spostamento.** Vale il doppio di quanto sembra, vedi il punto 3.

## 2. L'idea che mi è piaciuta di più: "Qualità del piano"

Misurare quanti scenari "pronti" raggiungono l'obiettivo o l'invalidazione, **indipendentemente da cosa fa il trader**, separa due domande che di solito si confondono: *il piano era buono?* e *l'ho eseguito bene?*

Un suggerimento per quando la costruirai: confronta sempre il risultato con quello che otterresti **per caso**. Un modo semplice è rimescolare le date degli scenari o prendere ingressi casuali alla stessa distanza dal prezzo. Se la percentuale di scenari riusciti non si stacca da quella casuale, il piano non aggiunge informazione anche se "sembra" buono. Per noi è stata la lezione più utile: molte soglie che sembrano ragionevoli, confrontate col caso, non misurano niente.

## 3. Tre trappole che abbiamo incontrato, e che il tuo sistema può incontrare

1. **L'orologio del broker non è per forza quello che pensi, e può cambiare nel tempo.** Il server di un broker può seguire o no l'ora legale, e alcuni broker hanno cambiato convenzione nel corso degli anni. Conseguenza: una strategia legata a un orario (range della notte, finestra pre-apertura, ORB) può leggere candele diverse d'estate e d'inverno senza che nessuno se ne accorga. **Suggerimento**: una volta all'anno, e a ogni cambio d'ora, controlla su un evento a orario fisso (per esempio un dato macro USA) a che ora compare sul grafico del broker.
2. **Gli orari delle strategie vanno scritti rispetto al mercato, non all'orologio.** Una finestra "07:00-08:55" è precisa solo finché mercato e orologio non si spostano. Scriverla come "fino a cinque minuti prima dell'apertura cash" la rende stabile tutto l'anno.
3. **Le soglie che le fonti lasciano aperte vanno chiuse con una misura, non con una scelta.** Fai bene a dichiararle "non verificabili". Quando le chiuderai, conviene fissare la regola di scelta **prima** di guardare i risultati, e scegliere il centro di una zona che funziona, non il punto migliore: il punto migliore di solito è rumore.

## 4. Spunti per il registro errori e per il Dottor Mind

- **Il registro è l'asset più prezioso del progetto**, perché cresce e nessuno lo può ricostruire dopo. Due campi che aggiungerei subito, perché dopo non si recuperano:
  - l'**orario d'ingresso rispetto all'apertura** (minuti prima o dopo), per vedere se gli errori si concentrano in certe fasi;
  - **cosa diceva il piano in quel momento**: pronto, bassa priorità o assente. Così "fuori piano" si divide in due casi diversi: *c'era un piano e l'ho ignorato*, oppure *non c'era un piano*.
- Sul **Dottor Mind**: partire da come si è sentito il trader prima dei numeri è una scelta molto matura. Aggiungerei una sola domanda fissa ogni settimana: *"qual è l'operazione che rifaresti identica?"*. Aiuta a non leggere il registro solo come elenco di colpe.

## 5. Quando arriverai alle statistiche per strategia

Tre regole che ci hanno evitato conclusioni sbagliate:
- **Serve un numero minimo di operazioni** prima di giudicare una strategia. Sotto quel numero il risultato è un indizio, non un verdetto.
- **Il costo dell'operazione va messo in rapporto alla distanza dello stop.** Una strategia con stop molto stretti può sembrare ottima sul grafico e perdere per lo spread. Conviene fissare un rapporto minimo fra stop e spread tipico, e scartare le strategie che non lo rispettano.
- **Distinguere il rischio dal merito.** Una strategia si può giudicare subito sul rischio (quanto può perdere in un giorno o in una serie) anche quando è troppo presto per dire se guadagna.

## 6. Possibili punti di scambio

I nostri due lavori sono complementari: il tuo parte dalle **regole e dalla disciplina del trader**, il nostro dalla **misura sistematica di strategie automatiche**. Parecchie famiglie di strategie del tuo elenco (range della notte, pre-apertura, ORB, SuperTrend, punte di Larry Williams) sono concetti che anche noi studiamo. Se ti va, possiamo confrontarci **sul metodo**: come si chiude una soglia aperta, come si controlla l'orologio del broker, come si confronta un risultato con il caso.

Complimenti per il lavoro: il dossier è chiaro, onesto sui limiti e costruito con principi solidi.

*Claudio*
